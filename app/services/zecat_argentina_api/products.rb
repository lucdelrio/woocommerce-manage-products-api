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

      # Variante genérica
      # product_list = ZecatArgentinaApi::Products.get_generic_product_by_family('64', '2', '5')
      # list = product_list.dig('generic_products')
      # Ropa
      # ZecatArgentinaApi::Products.get_generic_product_by_family('128', '1', '5')
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
          # images: fill_images_list(product.dig('images')),
          attributes: variation_names(product.dig('products'))
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
        {
          regular_price: product.dig('price').to_s,
          price: product.dig('price').to_s,
          sku: variation.dig('sku'),
          # name: description,
          manage_stock: true,
          # stock: variation.dig('stock'),
          stock_quantity: variation.dig('stock'),
          weight: product.dig('dimensions', 'weight').to_s,
          dimensions: {
            length: product.dig('dimensions', 'length').to_s,
            width: product.dig('dimensions', 'width').to_s,
            height: product.dig('dimensions', 'height').to_s
          },
          attributes: fill_variation_attributes(variation)
        }
      end

      def generic_variation_name(variation)
        description = variation.dig('element_description_1')
        description = "#{description} / #{variation.dig('element_description_2')}" if variation.dig('element_description_2')&.match?(/[a-z]/)
        description = "#{description} / #{variation.dig('element_description_3')}" if variation.dig('element_description_3')&.match?(/[a-z]/)
        description
      end

      #  [[{:id=>5, :option=>"Negro"}, {:id=>3, :option=>"X Small"}],
      #  [{:id=>5, :option=>"Negro"}, {:id=>3, :option=>"Small"}],
      #  [{:id=>5, :option=>"Gris Oscuro"}, {:id=>3, :option=>"Large"}],
      #  [{:id=>5, :option=>"Gris Oscuro"}, {:id=>3, :option=>"Medium"}],
      #  [{:id=>5, :option=>"Negro"}, {:id=>3, :option=>"Large"}],
      #  [{:id=>5, :option=>"Negro"}, {:id=>3, :option=>"XX Large"}],
      #  [{:id=>5, :option=>"Negro"}, {:id=>3, :option=>"X Large"}],
      #  [{:id=>5, :option=>"Gris Oscuro"}, {:id=>3, :option=>"Small"}],
      #  [{:id=>5, :option=>"Negro"}, {:id=>3, :option=>"Medium"}],
      #  [{:id=>5, :option=>"Gris Oscuro"}, {:id=>3, :option=>"X Small"}],
      #  [{:id=>5, :option=>"Gris Oscuro"}, {:id=>3, :option=>"X Large"}],
      #  [{:id=>5, :option=>"Gris Oscuro"}, {:id=>3, :option=>"XX Large"}],
      #  [{:id=>5, :option=>"Negro"}, {:id=>3, :option=>"3 X Large"}],
      #  [{:id=>5, :option=>"Negro"}, {:id=>3, :option=>"4 X Large"}]]


      # [{
      #   "id": 3,
      #   "name": "Talle",
      #   "slug": "pa_talle",
      #   "position": 1,
      #   "visible": true,
      #   "variation": true,
      #   "options": [
      #       "L",
      #       "M",
      #       "S"
      #   ]
      # }]
      def variation_names(variations)
        variation_attributes = []
        options_list = []

        variations.each do |variation|
          variation_attributes << ZecatArgentinaApi::Products.fill_variation_attributes(variation)
        end

        if variation_attributes.first.length == 1
          options_list << variation_attributes_for_product(variation_attributes.first[0][:id])
          options_list[0][:options] << variation_attributes.first[0][:option]
          return options_list
        end

        variation_attributes.first.each do |option|
          options_list << variation_attributes_for_product(option[:id])
        end

        variation_attributes.each do |color, size|
          options_list.each do |option|
            option[:options] << color[:option] if option[:id] == color[:id] && !(option[:options].include?(color[:option]))
            option[:options] << size[:option] if option[:id] == size[:id] && !(option[:options].include?(size[:option]))
          end
        end

        options_list
      end

      def create_option(product_attribute_id, description)
        terms = WoocommerceApi.get_product_attribute_terms_by_attribute_id(product_attribute_id)
        term = WoocommerceApi.get_term_by_name(terms, description)

        return if term.present?

        # Falta completar slug
        # Ejemplop: "name": "Blanco / Sin Grip / Clip Negro",
        #           "slug": "blanco-sin-grip-clip-negro",
        body = {
          name: description
        }
        response = WoocommerceApi.create_product_attribute_term(product_attribute_id, body)
        return JSON.parse(response.body) if response.success?

        WoocommerceApi.get_product_attribute_terms_by_attribute_id_and_term_id(product_attribute_id, JSON.parse(response.body)['data']['resource_id'])
      end

      def fill_variation_attributes(variation)
        response = []
        if variation.dig('size').empty? && variation.dig('color').empty?
          product_attribute = WoocommerceApi.find_or_create_product_attribute_by_name('Variante')
          create_option(product_attribute.dig('id'), generic_variation_name(variation))

          response << variation_attribute(product_attribute, generic_variation_name(variation))
        else
          product_attribute_color = WoocommerceApi.find_or_create_product_attribute_by_name('Color')
          create_option(product_attribute_color.dig('id'), variation.dig('color'))
          product_attribute_size = WoocommerceApi.find_or_create_product_attribute_by_name('Talle')
          create_option(product_attribute_size.dig('id'), variation.dig('size'))

          response << variation_attribute(product_attribute_color, variation.dig('color'))
          response << variation_attribute(product_attribute_size, variation.dig('size'))
        end

        response
      end

      def variation_attribute(product_attribute, option)
        {
          id: product_attribute.dig('id'),
          # name: "Variante",
          # slug: "pa_variante",
          # visible: true,
          # variation: true,
          option: option
        }
      end

      def variation_attributes_for_product(id)
        {
          id: id,
          # name: "Variante",
          # slug: "pa_variante",
          visible: true,
          variation: true,
          # position: 0,
          options: []
        }
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
