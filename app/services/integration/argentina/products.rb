# frozen_string_literal: true

module Integration
  module Argentina
    class Products
      def initialize
        @zecat_categories = ZecatArgentinaApi::Families.categories
        @woocommerces_categories = WoocommerceApi.categories
      end

      def iterate_categories_and_create
        Category.all.each_slice(2) do |group|
          group.each do |category|
            # category = ZecatArgentinaApi::Families.category_by_description('2024 Día de la niñez')
            zecat_category = ZecatArgentinaApi::Families.category_by_description(@zecat_categories, category.description)
            next unless zecat_category.present?

            puts 'Category Description'
            puts category.description
            create_products_by_category(category)
          end
        end
      end

      def create_products_by_category(category)
        products_list = ZecatArgentinaApi::Products.get_generic_product_by_family_with_pages(category.zecat_id, '1',
                                                                                              '10')

        create_products_from_list(products_list['generic_products'])

        return if products_list['total_pages'] == 1

        (products_list['total_pages'] - 1).times do |page|
          products_list = ZecatArgentinaApi::Products.get_generic_product_by_family_with_pages(category.zecat_id,
                                                                                                page + 2, '10')
          create_products_from_list(products_list['generic_products'])
        end
      end

      def create_products_from_list(products_list)
        products_list.each_slice(4) do |product_group|
          product_group.each do |product|
            full_product = ZecatArgentinaApi::Products.generic_product_by_id(product['id'])
            next unless full_product['generic_product'].present?

            local_product = find_or_create_local_product(product['id'])
            
            product_hash = ZecatArgentinaApi::Products.fill_product(full_product['generic_product'])
            # if local_product.last_sync.present?
            #   next if local_product.last_sync < Time.now - 5.hours
            # else
            #   product_hash = ZecatArgentinaApi::Products.fill_product(category = Category.find_by(description: family['description'])@zecat_categories, full_product['generic_product'])
              
            #   local_product.update(last_sync: nil) unless remote_available(local_product)              

            #   if local_product.product_hash.nil?
            #     woocommerce_product = WoocommerceApi.create_product(product_hash)
            #     sync_local(local_product, woocommerce_product, product_hash)
  
            #   elsif product_hash.to_json != local_product.product_hash.to_json
            #     woocommerce_product = WoocommerceApi.update_product(local_product.woocommerce_api_id, product_hash)
            #     sync_local(local_product, woocommerce_product, product_hash)
            #   end
            # end
            
            if local_product.last_sync.nil?

              woocommerce_product = WoocommerceApi.create_product(product_hash)
              sync_local(local_product, woocommerce_product, product_hash, full_product)

            elsif product_hash.to_json != local_product.product_hash.to_json

              woocommerce_product = WoocommerceApi.update_product(local_product.woocommerce_api_id, product_hash)
              sync_local(local_product, woocommerce_product, product_hash, full_product)

            else
              local_product.update(last_sync: Time.zone.now)
            end
          end
        end
      end

      def remote_available(local_product)
        WoocommerceApi.product_by_id(local_product.woocommerce_api_id).present?
      end

      def find_or_create_local_product(zecat_id)
        product_found = Product.find_by(zecat_id: zecat_id)

        return product_found if product_found.present?

        Product.create!(
          zecat_id: zecat_id
        )
      end

      def sync_local(local_product, woocommerce_product, product_hash, full_product)
        if local_product.woocommerce_api_id.nil?
          local_product.update(woocommerce_api_id: woocommerce_product['id'].to_s)
        end

        local_product.update(woocommerce_last_updated_at: Time.zone.now,
                              name: product_hash[:name], full_product: full_product,
                              description: product_hash[:description],
                              last_sync: Time.zone.now, product_hash: product_hash)
      end
    end
  end
end
