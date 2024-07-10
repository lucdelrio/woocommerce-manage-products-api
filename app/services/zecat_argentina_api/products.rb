# frozen_string_literal: true

module ZecatArgentinaApi
  class Products < ZecatArgentinaApi::Base
    class << self
      def get_generic_product
        url = "#{ZECAT_ENDPOINT}/generic_product"
        response = HTTParty.get(url)
        JSON.parse(response.body)
      end

      def get_generic_product_by_id(product_id)
        url = "#{ZECAT_ENDPOINT}/generic_product/#{product_id}"
        response = HTTParty.get(url)
        JSON.parse(response.body)
      end

      def get_generic_product_by_page_with_sort(sort_type, sort, page_number, limit)
        url = "#{ZECAT_ENDPOINT}/generic_product?order[#{sort_type}]=#{sort}&page=#{page_number}&limit=#{limit}"
        response = HTTParty.get(url)

        JSON.parse(response.body)

        # fill_products_hash(json_products['generic_products'])
      end

      def get_generic_product_by_family(family_id, page_number, limit)
        url = "#{ZECAT_ENDPOINT}/generic_product?families[]=#{family_id}&page=#{page_number}&limit=#{limit}"
        response = HTTParty.get(url)

        JSON.parse(response.body)

        # fill_products_hash(json_products['generic_products'])
      end

      def fill_products_hash(products)
        product_hash = []
        products.each do |product|
          product_hash << fill_product(product)
        end
      end

      def fill_product(product)
        {
          name: product.dig('name'),
          type: product.dig('products').empty? ? 'simple' : 'variable',
          price: product.dig('price'),
          description: product.dig('description'),
          # short_description: "Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.",
          categories: add_categories(product),
          images: fill_images_list(product.dig('images')),
          dimentions: {
            length: product.dig('length'),
            width: product.dig('width'),
            height: product.dig('height')
          },
          attributes: [
            # Evaluate to crate variations for size, color, et.
            {
              id: 2,
              # name: "Variante",
              # slug: "pa_variante",
              visible: true,
              variation: true,
              # position: 0,
              options: variation_names(product.dig('products'))
            }
          ]
          # tags: product.dig('tag')
        }
      end

      def add_categories(product)
        commerce_categories = WoocommerceApi.get_categories
        categories = []
        product.dig('families').each do |family|
          category = WoocommerceApi.get_category_by_description(commerce_categories, family.dig('description'))

          if category.nil?
            category_found = ZecatArgentinaApi::Families.get_category_by_description(family.dig('description'))
            category_hash = ZecatArgentinaApi::Families.category_hash(category_found)
            category = WoocommerceApi.create_category(category_hash)
          end

          categories << {id: category.dig('id').to_i}
        end

        categories
      end

      def fill_variation(product, variation)
        description = variation_name(variation)
        create_option(description)
        {
          regular_price: product.dig('price').to_s,
          price: product.dig('price').to_s,
          sku: variation.dig('sku'),
          # name: description,
          manage_stock: true,
          # stock: variation.dig('stock'),
          stock_quantity: variation.dig('stock'),
          attributes: [
            {
              id: 2,
              # name: "Variante",
              # slug: "pa_variante",
              # visible: true,
              # variation: true,
              option: description
            }
          ]
        }
      end

      def variation_name(variation)
        description = variation.dig('element_description_1')
        description = "#{description} / #{variation.dig('element_description_2')}" if variation.dig('element_description_2')&.match?(/[a-z]/)
        description = "#{description} / #{variation.dig('element_description_3')}" if variation.dig('element_description_3')&.match?(/[a-z]/)
        description
      end

      def variation_names(variations)
        options = []

        variations.each do |variation|
          options << variation_name(variation)
        end

        puts 'Variation Names'
        puts options
        options
      end

      def create_option(description)
        # WoocommerceApi.create_product_attribute_term(attribute_id)
        terms = WoocommerceApi.get_product_attribute_terms_by_attribute_id('2')
        term = WoocommerceApi.get_term_by_name(terms, description)

        return if term.present?

        # Falta completar slug
        # Ejemplop: "name": "Blanco / Sin Grip / Clip Negro",
        #           "slug": "blanco-sin-grip-clip-negro",
        body = {
          name: description
        }
        WoocommerceApi.create_product_attribute_term('2', body)
      end

      def fill_images_list(images_list)
        images = []
        images << find_main_image(images_list)
        images_list.each do |image|
          content = {
            src: image.dig('image_url')
          }
          images << content if image.dig('main') ==  false
        end

        images
      end
      
      def find_main_image(images_list)
        images_list.each do |image|
          return { src: image.dig('image_url')} if image.dig('main') ==  true
        end
      end
    end
  end
end
