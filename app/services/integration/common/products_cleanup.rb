# frozen_string_literal: true

module Integration
  module Common
    class ProductsCleanup
      class << self
        def iterate_products_and_destroy
          Product.all.each_slice(10) do |group|
            group.each do |local_product|
              zecat_product = ZecatArgentinaApi::Products.generic_product_by_id(local_product.zecat_id)
              woocommerce_product = WoocommerceApi.product_by_id(local_product.woocommerce_api_id)

              (local_product.destroy! ; next) unless local_product.woocommerce_api_id.present?

              next if zecat_product.present? && woocommerce_product.present?

              if zecat_product.present? && !woocommerce_product.present?
                local_product.update(last_sync: nil)
              elsif !zecat_product.present?
                local_product.destroy!
              end
            end
          end
        end
      end
    end
  end
end
