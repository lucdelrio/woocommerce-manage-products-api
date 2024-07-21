# frozen_string_literal: true

module Integration
  module Argentina
    class Attachments
      class << self
        def iterate_product_and_create
          zecat_product_ids = Attachment.all.map(&:zecat_product_id)
          Product.where.not(zecat_id: zecat_product_ids).each do |product|
            create_media_for_product(product)
          end
        end

        def create_media_for_product(product)
          Rails.logger.debug 'Attachments:Product'
          Rails.logger.debug product.zecat_id
          full_product = ZecatArgentinaApi::Products.generic_product_by_id(product.zecat_id)['generic_product']
          return unless full_product.present?

          create_product_media(product.woocommerce_api_id, full_product)
        end

        def create_product_media(woocommerce_api_product_id, full_product)
          full_product['images'].each do |image|
            media_hash = ZecatArgentinaApi::Products.fill_images_list([image])
            local_attachment = find_or_create_local_product_media(full_product['id'], image['id'],
                                                                  woocommerce_api_product_id)

            if (media_hash.to_json != local_attachment.media_hash.to_json) || local_attachment.last_sync.nil?
              woocommerce_media = WoocommerceApi.update_product(woocommerce_api_product_id, { images: media_hash })

              sync_local(local_attachment, woocommerce_media, media_hash)
            else
              local_attachment.update(last_sync: Time.zone.now)
            end
          end
        end

        def find_or_create_local_product_media(zecat_product_id, zecat_image_id, woocommerce_api_product_id)
          media_found = Attachment.find_by(zecat_product_id: zecat_product_id, zecat_media_id: zecat_image_id)

          return media_found if media_found.present?

          Attachment.create!(
            zecat_product_id: zecat_product_id,
            zecat_media_id: zecat_image_id,
            woocommerce_api_product_id: woocommerce_api_product_id
          )
        end

        def sync_local(local_attachment, woocommerce_media, media_hash)
          if woocommerce_media.dig('data', 'status') == 400
            local_attachment.destroy!
          else
            local_attachment.update(woocommerce_last_updated_at: Time.zone.now,
                                    woocommerce_api_id: woocommerce_media['id'].to_s,
                                    last_sync: Time.zone.now, media_hash: media_hash)
          end
        end
      end
    end
  end
end
