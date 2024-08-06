# frozen_string_literal: true

module Integration
  class Attachments
    def initialize(zecat_country = 'Argentina')
      @zecat_country = zecat_country
    end

    def iterate_product_and_create
      Product.all.each do |product|
        create_media_for_product(product)
      end
    end

    def create_media_for_product(product)
      Rails.logger.info 'Attachments:Product'
      Rails.logger.info product.zecat_id

      return unless product.zecat_hash.present?

      create_product_media(product.woocommerce_api_id, product.zecat_hash)
    end

    def create_product_media(woocommerce_api_product_id, full_product)
      return unless full_product['images'].present?

      media_hash = EntityGeneration::Attachments.fill_images_list(full_product['images'], full_product['products'])

      local_attachment = find_or_create_local_product_media(full_product['id'],
                                                            woocommerce_api_product_id)

      if (media_hash != local_attachment.media_hash) || local_attachment.last_sync.nil?
        response = WoocommerceApi.update_product(woocommerce_api_product_id, { images: media_hash })

        if response.success?
          sync_local(local_attachment, JSON.parse(response.body), media_hash)
        else
          AttachmentsSetupJob.perform_in(20.minutes, Product.find_by(woocommerce_api_id: woocommerce_api_product_id).id)
        end
      else
        local_attachment.update(last_sync: Time.zone.now)
      end
    end

    def find_or_create_local_product_media(zecat_product_id, woocommerce_api_product_id)
      media_found = Attachment.find_by( zecat_product_id: zecat_product_id.to_i,
                                        woocommerce_api_product_id: woocommerce_api_product_id.to_i,
                                        country: @zecat_country
                                      )

      return media_found if media_found.present?

      Attachment.new(
        zecat_product_id: zecat_product_id,
        woocommerce_api_product_id: woocommerce_api_product_id,
        country: @zecat_country
      )
    end

    def sync_local(local_attachment, woocommerce_media, media_hash)
      if woocommerce_media.dig('data', 'status') == 400
        local_attachment.destroy!
      else
        local_attachment.update(woocommerce_last_updated_at: Time.zone.now,
                                last_sync: Time.zone.now, media_hash: media_hash)
      end
    end
  end
end
