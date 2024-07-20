# frozen_string_literal: true

class CreateArgentinaProducts
  class << self
    def iterate_categories_and_create_products
      categories = WoocommerceApi.get_categories
      categories.each_slice(2) do |group|
        group.each do |category|
          create_products_by_category(category['description'])
        end
      end
    end

    def create_products_by_category(description)
      # category = ZecatArgentinaApi::Families.get_category_by_description('2024 Día de la niñez')
      category = ZecatArgentinaApi::Families.get_category_by_description(description)
      category['id']
      products_list = ZecatArgentinaApi::Products.get_generic_product_by_family_with_pages(category['id'], '1',
                                                                                           '10')

      create_products_from_list(products_list['generic_products'])

      return if products_list['total_pages'] == 1

      (products_list['total_pages'] - 1).times do |page|
        products_list = ZecatArgentinaApi::Products.get_generic_product_by_family_with_pages(category['id'],
                                                                                             page + 2, '10')
        create_products_from_list(products_list['generic_products'])
      end
    end

    def create_products_from_list(products_list)
      full_product_list = []
      products_list.each_slice(4) do |product_group|
        product_group.each do |product|
          full_product = ZecatArgentinaApi::Products.get_generic_product_by_id(product['id'])['generic_product']
          product_hash = ZecatArgentinaApi::Products.fill_product(full_product)
          response = WoocommerceApi.create_product(product_hash)

          full_product_list << { id: response['id'], product: full_product }
        end
      end

      create_product_variations(full_product_list)
      create_product_images(full_product_list)
    end

    def create_product_variations(full_product_list)
      full_product_list.each do |full_product|
        full_product[:product]['products'].each do |variation|
          product_variation = ZecatArgentinaApi::Products.fill_variation(full_product[:product], variation)
          WoocommerceApi.create_product_variation(full_product[:id], product_variation)
        end
      end
    end

    def create_product_images(full_product_list)
      full_product_list.each do |full_product|
        full_product[:product]['images'].each_slice(4) do |group|
          WoocommerceApi.update_product(full_product[:id],
                                        { images: ZecatArgentinaApi::Products.fill_images_list(group) })
        end
      end
    end
  end
end
