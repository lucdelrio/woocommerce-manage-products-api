# frozen_string_literal: true

module Integration
  class ProductCustomizations
    class << self
      def iterate_products_and_create_customization
        Product.find_in_batches do |group|
          group.each do |product|
            zecat_product = CountrySelection.zecat_class_name(product.country)::Products.generic_product_by_id(product.zecat_id)
            next unless zecat_product['generic_product'].present?

            customization = find_or_create_customization(product)
            minimum_application_quantity = zecat_product.dig('generic_product', 'minimum_application_quantity')
            next if customization.minimum_application_quantity == minimum_application_quantity

            customization.update(minimum_application_quantity: minimum_application_quantity)
          end
        end
      end

      def find_or_create_customization(product)
        customization = ProductCustomization.find_by(product_id: product.id, country: product.country)

        return customization if customization.present?

        ProductCustomization.new(
          product_id: product.id, country: product.country,
          zecat_product_id: product.zecat_id, woocommerce_api_id: product.woocommerce_api_id
        )
      end

      def clean_customizations
        ProductCustomization.find_in_batches do |group|
          group.each do |customization|
            product = Product.find_by(country: customization.country, zecat_id: customization.zecat_product_id,
                                      id: customization.product_id, woocommerce_api_id: customization.woocommerce_api_id)

            next if product.present?

            customization.destroy!
          end
        end
      end
    end
  end
end
