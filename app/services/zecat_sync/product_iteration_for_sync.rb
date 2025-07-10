# frozen_string_literal: true

module ZecatSync
  class ProductIterationForSync
    def initialize(zecat_country)
      @zecat_country = zecat_country
    end

    # This method iterates through all products in Zecat and schedules a job to create them in database and WooCommerce.
    # It fetches products in pages of 50, starting from page 1.
    def iterate_products_and_create
      products_list = CountrySelection.zecat_class_name(@zecat_country)::Products.get_generic_product_by_page('1', '50')

      create_products_from_list(products_list['generic_products'])

      return if products_list['total_pages'] == 1

      (products_list['total_pages'] - 1).times do |page|
        products_list = CountrySelection.zecat_class_name(@zecat_country)::Products.get_generic_product_by_page(
          page + 2, '50'
        )
        create_products_from_list(products_list['generic_products'])
      end
    end
    
    def create_products_from_list(products_list)
      return if (!products_list.present? || products_list&.empty?)

      products_list.each_slice(4) do |product_group|
        product_group.each do |zecat_product|
          next if zecat_product['isKit'] == true

          ProductSetupJob.perform_in(20.seconds, zecat_product['id'].to_i, @zecat_country)
        end
      end
    end
  end
end
