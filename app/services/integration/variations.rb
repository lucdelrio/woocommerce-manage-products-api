# frozen_string_literal: true

module Integration
  class Variations
    def initialize(zecat_country = 'Argentina')
      @zecat_country = zecat_country
    end
    
    def iterate_product_and_create
      Product.all.each_slice(5) do |product_group|
        product_group.each do |product|
          # full_product = ZecatApi::Products.generic_product_by_id(product.zecat_id)
          next unless product.zecat_hash.present?

          create_product_variations(product.woocommerce_api_id, product.zecat_hash)
        end
      end
    end

    def create_product_variations(woocommerce_api_product_id, full_product)
      return unless full_product['products'].present?

      full_product['products'].each do |variation|
        product_variation_hash = EntityGeneration::Products.new(@zecat_country).fill_variation(full_product, variation)

        local_variation = find_or_create_local_product_variation(variation['generic_product_id'], variation['id'], woocommerce_api_product_id)

        if local_variation.last_sync.nil?
          woocommerce_variation = CountrySelection::woocommerce_class_name(@zecat_country).create_product_variation(woocommerce_api_product_id,
                                                                          product_variation_hash)

          sync_local(local_variation, woocommerce_variation, product_variation_hash)
        elsif product_variation_hash.to_json != local_variation.variation_hash.to_json
          woocommerce_variation = CountrySelection::woocommerce_class_name(@zecat_country).update_product_variation(woocommerce_api_product_id,
                                                                          local_variation.woocommerce_api_id,
                                                                          product_variation_hash)

          sync_local(local_variation, woocommerce_variation, product_variation_hash)
        else
          local_variation.update(last_sync: Time.zone.now)
        end
      end
    end

    def find_or_create_local_product_variation(zecat_product_id, zecat_variation_id, woocommerce_api_product_id)
      variation_found = Variation.find_by(zecat_product_id: zecat_product_id.to_i,
                                          zecat_variation_id: zecat_variation_id.to_i,
                                          country: @zecat_country)

      return variation_found if variation_found.present?

      Variation.new(
        zecat_product_id: zecat_product_id,
        zecat_variation_id: zecat_variation_id,
        woocommerce_api_product_id: woocommerce_api_product_id,
        country: @zecat_country
      )
    end

    def sync_local(local_variation, woocommerce_variation, product_variation_hash)
      woocommerce_variation_id = if woocommerce_variation.success?
        JSON.parse(woocommerce_variation.body)['id']
      else
        JSON.parse(woocommerce_variation.body)['data']['resource_id']
      end

      local_variation.update(woocommerce_api_id: woocommerce_variation_id) if local_variation.woocommerce_api_id.nil?

      local_variation.update(woocommerce_last_updated_at: Time.zone.now, regular_price: product_variation_hash[:regular_price].to_f,
                              last_sync: Time.zone.now, variation_hash: product_variation_hash)
    end
  end
end
