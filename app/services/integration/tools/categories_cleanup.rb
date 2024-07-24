# frozen_string_literal: true

module Integration
  module Tools
    class CategoriesCleanup
      def initialize
        @zecat_categories = ZecatApi::Families.categories
      end

      def iterate_categories_and_destroy
        Category.all.each_slice(10) do |group|
          group.each do |local_category|
            zecat_category = ZecatApi::Families.category_by_id(@zecat_categories, local_category.zecat_id)
            woocommerce_category = WoocommerceApi.category_by_id(local_category.woocommerce_api_id)

            next if !zecat_category.nil? && woocommerce_category.present?

            if !zecat_category.nil? && !woocommerce_category.present?
              local_category.update(last_sync: nil)
            elsif zecat_category.nil?
              local_category.destroy!
            end
          end
        end
      end
    end
  end
end
