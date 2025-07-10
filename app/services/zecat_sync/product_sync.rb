# frozen_string_literal: true

module ZecatSync
  class ProductSync
    def initialize(zecat_product_id, zecat_country)
      @zecat_product_id = zecat_product_id
      @zecat_country = zecat_country
    end

    # Logic to sync the product
    def sync_product
      full_product = CountrySelection.zecat_class_name(@zecat_country)::Products.generic_product_by_id(@zecat_product_id)
      return unless full_product['generic_product'].present?

      local_product = find_or_create_local_product(@zecat_product_id)

      product_hash = EntityGeneration::Products.new(@zecat_country).fill_product(full_product['generic_product'])

      if local_product.woocommerce_api_id.nil?

        woocommerce_product = CountrySelection.woocommerce_class_name(@zecat_country).create_product(product_hash)

        sync_local(local_product, woocommerce_product, product_hash, full_product['generic_product'])

      elsif product_hash.to_json != local_product.product_hash.to_json
        response = CountrySelection.woocommerce_class_name(@zecat_country).update_product(
          local_product.woocommerce_api_id, product_hash
        )

        if response.success?
          sync_local(local_product, JSON.parse(response.body), product_hash, full_product['generic_product'])
        else
          ProductSetupJob.perform_in(20.minutes, zecat_product_id, @zecat_country)
        end
      elsif local_product.zecat_hash != full_product['generic_product']
        sync_local(local_product, { 'id' => local_product.woocommerce_api_id }, product_hash,
                  full_product['generic_product'])
      end
    end

    private

    # Find or create a local product based on the zecat_id
    # @param zecat_id [Integer] The ID of the product in Zecat
    # @return [Product] The found or newly created Product instance
    def find_or_create_local_product(zecat_id)
      product_found = Product.find_by(zecat_id: zecat_id.to_i, country: @zecat_country)

      return product_found if product_found.present?

      Product.new(
        zecat_id: zecat_id, country: @zecat_country
      )
    end

    # Sync the local product with the data from WooCommerce
    # @param woocommerce_product [Hash] The product data from WooCommerce
    # @param product_hash [Hash] The product data to be saved locally
    # @param full_product [Hash] The full product data from Zecat
    def sync_local(woocommerce_product, product_hash, full_product)
      return unless woocommerce_product['id'].present?

      Rails.logger.info "Update/Sync Local Product #{woocommerce_product['id']}"

      begin
        @product.update(woocommerce_last_updated_at: Time.zone.now,
                        woocommerce_api_id: woocommerce_product['id'],
                        name: product_hash[:name], zecat_hash: full_product,
                        description: product_hash[:description],
                        last_sync: Time.zone.now, product_hash: product_hash)
      rescue Net::ReadTimeout => e
        Rails.logger.info "Net::ReadTimeout Error | #{e.message}"

        @product.update(woocommerce_last_updated_at: Time.zone.now,
                        woocommerce_api_id: woocommerce_product['id'],
                        name: product_hash[:name], zecat_hash: full_product)
        @product.update(description: product_hash[:description],
                        last_sync: Time.zone.now, product_hash: product_hash)
      end
    end
  end
end
