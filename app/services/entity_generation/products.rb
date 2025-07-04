# frozen_string_literal: true

module EntityGeneration
  class Products
    PROHIBITED_SYMBOLS = ['.', '-', '..', '...']
    PROHIBITED_VARIANTS = ['Telas', 'Material']
    PRINTING_TYPE_ATTRIBUTE = ENV.fetch('PRINTING_TYPE_ATTRIBUTE', 'Tipo de Aplicación')
    PRINTING_TYPE_DEFAULT_VALUE = ENV.fetch('PRINTING_TYPE_DEFAULT_VALUE', 'Sin Aplicación')

    def initialize(zecat_country)
      @country = zecat_country
      @price_increase = ENV.fetch("#{@country.upcase}_PRICE_INCREASE", 1.0).to_f
    end

    def fill_product(product)
      {
        name: product['name'],
        type: product['products'].empty? ? 'simple' : 'variable',
        description: product['description'],
        categories: add_categories(product),
        attributes: variation_names(product, product['products'])
        # tags: product.dig('tag')
      }
    end

    def add_categories(product)
      categories = []
      product['families'].each do |family|
        category = Category.find_by(name: family['description'], country: @country)
        next if category.nil?

        categories << { id: category.woocommerce_api_id.to_i }
      end

      categories
    end

    def fill_variation(product, variation)
      {
        regular_price: (product['price'] * @price_increase).round(2).to_s,
        sku: variation['sku'],
        manage_stock: true,
        stock_quantity: variation['stock'],
        weight: product.dig('dimensions', 'weight').to_s,
        dimensions: {
          length: product.dig('dimensions', 'length').to_s,
          width: product.dig('dimensions', 'width').to_s,
          height: product.dig('dimensions', 'height').to_s
        },
        attributes: product.dig('buyBySize') ? fill_apparel_variation_attributes(variation) : fill_variation_attributes(variation)
      }
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
    def variation_names(product, variations)
      variation_attributes = []
      options_list = []
      return if variations.empty?

      variations.each do |variation|
        variation_attributes << (product.dig('buyBySize') ? fill_apparel_variation_attributes(variation) : fill_variation_attributes(variation))
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

      options_list << add_printing_types(product)
    end

    def find_or_create_option(product_attribute_id, description)
      term = ProductAttributeTerm.find_by(woocommerce_api_product_attribute_id: product_attribute_id.to_i,
                                          name: description, country: @country)
      return if term.present?

      body = { name: description }
      woocommerce_term = CountrySelection::woocommerce_class_name(@country).create_product_attribute_term(product_attribute_id,
                                                                                                          body)

      ProductAttributeTerm.create(name: description, woocommerce_api_id: woocommerce_term['id'],
                                  term_hash: body,
                                  country: @country,
                                  woocommerce_last_updated_at: Time.zone.now,
                                  last_sync: Time.zone.now,
                                  woocommerce_api_product_attribute_id: product_attribute_id)
      # return JSON.parse(response.body) if response.success?

      # WoocommerceApi.get_product_attribute_terms_by_attribute_id_and_term_id(product_attribute_id,
      #                                                                        JSON.parse(response.body)['data']['resource_id'])
    end

    def fill_apparel_variation_attributes(variation)
      response = []

      if ["Talle", "Tallle", "Talles"].include?(variation['attribute_1']) && variation['attribute_2'] == "Color" 
        product_attribute_1 = find_or_create_product_attribute_by_name('Talle')
        find_or_create_option(product_attribute_1.woocommerce_api_id, variation['element_description_1'])
        response << variation_attribute(product_attribute_1.woocommerce_api_id, variation['element_description_1'])

        if variation['attribute_2'].present? && !variation['element_description_2'].in?(PROHIBITED_SYMBOLS)
          product_attribute_2 = find_or_create_product_attribute_by_name('Color')
          find_or_create_option(product_attribute_2.woocommerce_api_id, variation['element_description_2'])
          response << variation_attribute(product_attribute_2.woocommerce_api_id, variation['element_description_2'])
        end
        
        if variation['attribute_3'].present? && !variation['element_description_3'].in?(PROHIBITED_SYMBOLS) && !variation['attribute_3'].in?(PROHIBITED_VARIANTS)
          product_attribute_3 = find_or_create_product_attribute_by_name(variation['attribute_3'])
          find_or_create_option(product_attribute_3.woocommerce_api_id, variation['element_description_3'])
          response << variation_attribute(product_attribute_3.woocommerce_api_id, variation['element_description_3'])
        end
      else
        if variation['attribute_1'].present? && !variation['attribute_1'].in?(PROHIBITED_VARIANTS) && !variation['element_description_1'].in?(PROHIBITED_SYMBOLS)
          product_attribute_1 = find_or_create_product_attribute_by_name(variation['attribute_1'])
          find_or_create_option(product_attribute_1.woocommerce_api_id, variation['element_description_1'])
          response << variation_attribute(product_attribute_1.woocommerce_api_id, variation['element_description_1'])
        end

        if variation['attribute_2'].present? && !variation['attribute_2'].in?(PROHIBITED_VARIANTS) && !variation['element_description_2'].in?(PROHIBITED_SYMBOLS)
          product_attribute_2 = find_or_create_product_attribute_by_name(variation['attribute_2'])
          find_or_create_option(product_attribute_2.woocommerce_api_id, variation['element_description_2'])
          response << variation_attribute(product_attribute_2.woocommerce_api_id, variation['element_description_2'])
        end
        
        if variation['attribute_3'].present? && !variation['attribute_3'].in?(PROHIBITED_VARIANTS) && !variation['element_description_3'].in?(PROHIBITED_SYMBOLS)
          product_attribute_3 = find_or_create_product_attribute_by_name(variation['attribute_3'])
          find_or_create_option(product_attribute_3.woocommerce_api_id, variation['element_description_3'])
          response << variation_attribute(product_attribute_3.woocommerce_api_id, variation['element_description_3'])
        end
      end

      response
    end

    def fill_variation_attributes(variation)
      response = []

      product_attribute_1 = find_or_create_product_attribute_by_name('Color')
      find_or_create_option(product_attribute_1.woocommerce_api_id, variation['attribute_1'])

      if variation['attribute_2'].present? && !variation['element_description_2'].in?(PROHIBITED_SYMBOLS) && variation['attribute_3'].present? && variation.dig('attribute_3') != "Sin Atributos" && !variation['element_description_3'].in?(PROHIBITED_SYMBOLS)
        response << variation_attribute(product_attribute_1.woocommerce_api_id, "#{variation['element_description_1']} / #{variation['element_description_2']} / #{variation['element_description_3']}")
      elsif variation['attribute_2'].present? && !variation['element_description_2'].in?(PROHIBITED_SYMBOLS)
        response << variation_attribute(product_attribute_1.woocommerce_api_id, "#{variation['element_description_1']} / #{variation['element_description_2']}")
      else
        response << variation_attribute(product_attribute_1.woocommerce_api_id, variation['element_description_1'])
      end

      response
    end

    def add_printing_types(product)
      application_attribute = find_or_create_product_attribute_by_name(PRINTING_TYPE_ATTRIBUTE)
      variation_attribute = variation_attributes_for_product(application_attribute.woocommerce_api_id)
      variation_attribute[:options].concat([PRINTING_TYPE_DEFAULT_VALUE], (product&.dig('printing_types') || [])&.pluck('name').uniq)
      variation_attribute
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

    def find_or_create_product_attribute_by_name(name)
      product_attribute = ProductAttribute.find_by(name: name, country: @country)

      return product_attribute if product_attribute.present?

      woocommerce_product_attribute = CountrySelection::woocommerce_class_name(@country).create_product_attribute({ name: name })
      # woocommerce_product_attribute.dig('id')

      ProductAttribute.create(name: name, woocommerce_api_id: woocommerce_product_attribute['id'],
                              attribute_hash: { name: name },
                              country: @country,
                              last_sync: Time.zone.now, woocommerce_last_updated_at: Time.zone.now)
    end
  end
end
