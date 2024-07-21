# frozen_string_literal: true

module ZecatArgentinaApi
  class Products < ZecatArgentinaApi::Base
    class << self
      def get_generic_product
        url = "#{ZECAT_ENDPOINT}/generic_product"
        response = HTTParty.get(url)
        JSON.parse(response.body)
      end

      def generic_product_by_id(product_id)
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
      # product_list = ZecatArgentinaApi::Products.get_generic_product_by_family_with_pages('64', '2', '5')
      # list = product_list.dig('generic_products')
      # Ropa
      # ZecatArgentinaApi::Products.get_generic_product_by_family_with_pages('128', '1', '5')
      def get_generic_product_by_family_with_pages(family_id, page_number, limit)
        url = "#{ZECAT_ENDPOINT}/generic_product?families[]=#{family_id}&page=#{page_number}&limit=#{limit}"
        response = HTTParty.get(url)

        JSON.parse(response.body)

        # fill_products_hash(json_products['generic_products'])
      end

      # def fill_products_hash(products)
      #   product_hash = []
      #   products.each do |product|
      #     product_hash << fill_product(product)
      #   end
      # end

      def fill_product(product)
        {
          name: product['name'],
          type: product['products'].empty? ? 'simple' : 'variable',
          price: product['price'],
          description: product['description'],
          # short_description: "Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.",
          categories: add_categories(product),
          # images: fill_images_list(product.dig('images')),
          attributes: variation_names(product['products'])
          # tags: product.dig('tag')
        }
      end

      def add_categories(product)
        categories = []
        product['families'].each do |family|
          category = Category.find_by(description: family['description'])
          next if category.nil?

          categories << { id: category.woocommerce_api_id.to_i }
        end

        categories
      end

      def fill_variation(product, variation)
        {
          regular_price: product['price'].to_s,
          price: product['price'].to_s,
          sku: variation['sku'],
          # name: description,
          manage_stock: true,
          # stock: variation.dig('stock'),
          stock_quantity: variation['stock'],
          weight: product.dig('dimensions', 'weight').to_s,
          dimensions: {
            length: product.dig('dimensions', 'length').to_s,
            width: product.dig('dimensions', 'width').to_s,
            height: product.dig('dimensions', 'height').to_s
          },
          attributes: fill_variation_attributes(variation)
        }
      end

      # def generic_variation_name(variation)
      #   description = variation['element_description_1']
      #   if variation['element_description_2']&.match?(/[a-z]/)
      #     description = "#{description} / #{variation['element_description_2']}"
      #   end
      #   if variation['element_description_3']&.match?(/[a-z]/)
      #     description = "#{description} / #{variation['element_description_3']}"
      #   end
      #   description
      # end

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
        return if variations.empty?

        variations.each do |variation|
          variation_attributes << ZecatArgentinaApi::Products.fill_variation_attributes(variation)
        end

        variation_attributes.first.each do |option|
          options_list << variation_attributes_for_product(option[:id])
        end

        variation_attributes.each do |one, two, three|
          options_list.each do |option|
            option[:options] << one[:option] if option[:id] == one[:id] && option[:options].exclude?(one[:option])
            next unless two.present?

            option[:options] << two[:option] if option[:id] == two[:id] && option[:options].exclude?(two[:option])
            next unless three.present?

            option[:options] << three[:option] if option[:id] == three[:id] && option[:options].exclude?(three[:option])
          end
        end

        options_list
      end

      def create_option(product_attribute_id, description)
        # term = WoocommerceApi.get_term_by_name(terms, description)
        term = ProductAttributeTerm.find_by(woocommerce_api_product_attribute_id: product_attribute_id,
                                            name: description)

        return if term.present?

        # Falta completar slug
        # Ejemplop: "name": "Blanco / Sin Grip / Clip Negro",
        #           "slug": "blanco-sin-grip-clip-negro",
        body = { name: description }
        woocommerce_term = WoocommerceApi.create_product_attribute_term(product_attribute_id,
                                                                        body)

        ProductAttributeTerm.create(name: description, woocommerce_api_id: woocommerce_term['id'],
                                    term_hash: body,
                                    woocommerce_last_updated_at: Time.zone.now,
                                    last_sync: Time.zone.now,
                                    woocommerce_api_product_attribute_id: product_attribute_id)
        # return JSON.parse(response.body) if response.success?

        # WoocommerceApi.get_product_attribute_terms_by_attribute_id_and_term_id(product_attribute_id,
        #                                                                        JSON.parse(response.body)['data']['resource_id'])
      end

      def fill_variation_attributes(variation)
        prohibited_symbols = ['.', '-', '..', '...']
        response = []

        product_attribute_1 = find_or_create_product_attribute_by_name(variation['attribute_1'])
        create_option(product_attribute_1.woocommerce_api_id, variation['attribute_1'])
        response << variation_attribute(product_attribute_1.woocommerce_api_id, variation['element_description_1'])

        if variation['attribute_2'].present? && !variation['element_description_2'].in?(prohibited_symbols)
          product_attribute_2 = find_or_create_product_attribute_by_name(variation['attribute_2'])
          create_option(product_attribute_2.woocommerce_api_id, variation['attribute_2'])
          response << variation_attribute(product_attribute_2.woocommerce_api_id, variation['element_description_2'])
        end

        if variation['attribute_3'].present? && !variation['element_description_3'].in?(prohibited_symbols)
          product_attribute_3 = find_or_create_product_attribute_by_name(variation['attribute_3'])
          create_option(product_attribute_3.woocommerce_api_id, variation['attribute_3'])
          response << variation_attribute(product_attribute_3.woocommerce_api_id, variation['element_description_3'])
        end

        response
      end

      def variation_attribute(product_attribute_id, option)
        {
          id: product_attribute_id,
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
            src: image['image_url']
          }
          images << content if image['main'] == false
        end

        images
      end

      def find_main_image(images_list)
        images_list.each do |image|
          return { src: image['image_url'] } if image['main'] == true
        end
      end

      def find_or_create_product_attribute_by_name(name)
        product_attribute = ProductAttribute.find_by(name: name)
  
        return product_attribute if product_attribute.present?
  
        woocommerce_product_attribute = WoocommerceApi.create_product_attribute({ name: name })
  
        ProductAttribute.create(name: name, woocommerce_api_id: woocommerce_product_attribute['id'],
                                last_sync: Time.zone.now, woocommerce_last_updated_at: Time.zone.now)
      end
    end
  end
end
