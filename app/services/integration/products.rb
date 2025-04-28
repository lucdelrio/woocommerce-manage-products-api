# frozen_string_literal: true

module Integration
  class Products
    def initialize(zecat_country)
      @zecat_country = zecat_country
    end

    def iterate_categories_and_create
      zecat_categories = CountrySelection.zecat_class_name(@zecat_country)::Families.categories
      Category.all.each_slice(2) do |group|
        group.each do |category|
          # category = ZecatApi::Families.category_by_description('2024 Día de la niñez')
          zecat_category = CountrySelection.zecat_class_name(@zecat_country)::Families.category_by_description(
            zecat_categories, category.description
          )
          next unless zecat_category.present?

          create_products_by_category(category, @zecat_country)
        end
      end
    end

    def create_products_by_category(category)
      products_list = CountrySelection.zecat_class_name(@zecat_country)::Products.get_generic_product_by_family_with_pages(category.zecat_id, '1',
                                                                                                                           '10')

      create_products_from_list(products_list['generic_products'])

      return if products_list['total_pages'] == 1

      (products_list['total_pages'] - 1).times do |page|
        products_list = CountrySelection.zecat_class_name(@zecat_country)::Products.get_generic_product_by_family_with_pages(category.zecat_id,
                                                                                                                             page + 2, '10')
        create_products_from_list(products_list['generic_products'])
      end
    end

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
      return if products_list.empty?

      products_list.each_slice(4) do |product_group|
        product_group.each do |zecat_product|
          next if zecat_product['isKit'] == true

          ProductSetupJob.perform_in(20.seconds, zecat_product['id'].to_i, @zecat_country)
        end
      end
    end

    def create_or_sync_product(zecat_product_id)
      full_product = CountrySelection.zecat_class_name(@zecat_country)::Products.generic_product_by_id(zecat_product_id)
      return unless full_product['generic_product'].present?

      local_product = find_or_create_local_product(zecat_product_id)

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

    def find_or_create_local_product(zecat_id)
      product_found = Product.find_by(zecat_id: zecat_id.to_i, country: @zecat_country)

      return product_found if product_found.present?

      Product.new(
        zecat_id: zecat_id, country: @zecat_country
      )
    end

    def sync_local(local_product, woocommerce_product, product_hash, full_product)
      return unless woocommerce_product['id'].present?

      Rails.logger.info "Update/Sync Local Product #{woocommerce_product['id']}"

      begin
        local_product.update(woocommerce_last_updated_at: Time.zone.now,
                             woocommerce_api_id: woocommerce_product['id'],
                             name: product_hash[:name], zecat_hash: full_product,
                             description: product_hash[:description],
                             last_sync: Time.zone.now, product_hash: product_hash)
      rescue Net::ReadTimeout => e
        Rails.logger.info "Net::ReadTimeout Error | #{e.message}"

        local_product.update(woocommerce_last_updated_at: Time.zone.now,
                             woocommerce_api_id: woocommerce_product['id'],
                             name: product_hash[:name], zecat_hash: full_product)
        local_product.update(description: product_hash[:description],
                             last_sync: Time.zone.now, product_hash: product_hash)
      end
    end
  end
end
