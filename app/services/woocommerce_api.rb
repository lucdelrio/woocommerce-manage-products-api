# frozen_string_literal: true

class WoocommerceApi
  WOOCOMMERCE_ENDPOINT = ENV.fetch('WOOCOMMERCE_ENDPOINT')
  CONSUMER_KEY = ENV.fetch('WOOCOMMERCE_CONSUMER_KEY')
  CONSUMER_SECRET = ENV.fetch('WOOCOMMERCE_CONSUMER_SECRET')

  class << self

    def get_products
      url = "#{WOOCOMMERCE_ENDPOINT}/products?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"
      response = HTTParty.get(url)
      JSON.parse(response.body)
    end

    def get_product_attributes
      url = "#{WOOCOMMERCE_ENDPOINT}/products/attributes?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"
      response = HTTParty.get(url)
      JSON.parse(response.body)
    end

    def get_categories
      url = "#{WOOCOMMERCE_ENDPOINT}/products/categories?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"
      response = HTTParty.get(url)
      JSON.parse(response.body)
    end

    def get_category_by_name(categories, name)
      categories.each do |category|
        return category if category.dig('name') == name
      end

      nil
    end

    def get_category_by_description(categories, description)
      categories.each do |category|
        return category if category.dig('description') == description
      end

      nil
    end

    def create_product(product)
      url = "#{WOOCOMMERCE_ENDPOINT}/products?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"
      response = HTTParty.post(url, body: product.to_json, headers: {'Content-Type' => 'application/json'} )

      puts 'Product body'
      puts product
      puts 'Create Product'
      puts JSON.parse(response.body)
      JSON.parse(response.body)

      # return if response.success?

      # raise ThirdPartyApiError.new({ url: url, message: response.body }, response.code)
    end

    def update_product(id, product)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/#{id}?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"
      response = HTTParty.put(url, body: product.to_json, headers: {'Content-Type': 'application/json'})
      puts 'Product body'
      puts product
      puts 'Update Product'
      puts JSON.parse(response.body)
      JSON.parse(response.body)

      # return if response.success?

      # raise ThirdPartyApiError.new({ url: url, message: response.body }, response.code)
    end

    # def create_product_with_variations(product)
    #   full_product = ZecatArgentinaApi::Products.get_generic_product_by_id(product.dig('id')).dig('generic_product')
    #   product_hash = ZecatArgentinaApi::Products.fill_product(full_product)
    #   response = create_product(product_hash)
    #   full_product.dig('products').each do |variation|
    #     product_variation = ZecatArgentinaApi::Products.fill_variation(full_product, variation)
    #     create_product_variation(response.dig('id'), product_variation)
    #   end

    #   response
    # end

    def create_product_variation(product_id, variation)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/#{product_id}/variations?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"
      response = HTTParty.post( url, body: variation.to_json, headers: {'Content-Type': 'application/json'})

      puts 'Variation'
      puts variation
      puts 'Create Product Variation'
      puts JSON.parse(response.body)
    end

    def create_product_attribute(attribute)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/attributes?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"

      response = HTTParty.post( url, body: attribute )
      JSON.parse(response.body)
    end

    def create_product_attribute_term(attribute_id, attribute)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/attributes/#{attribute_id}/terms?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"

      HTTParty.post( url, body: attribute )
    end

    def get_product_attribute_terms_by_attribute_id(attribute_id)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/attributes/#{attribute_id}/terms?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"

      response = HTTParty.get( url)
      JSON.parse(response.body)
    end

    def get_product_attribute_terms_by_attribute_id_and_term_id(attribute_id, term_id)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/attributes/#{attribute_id}/terms/#{term_id}?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"

      response = HTTParty.get( url)
      JSON.parse(response.body)
    end

    def get_term_by_name(term_list, name)
      term_list.each do |term|
        return term if term.dig('name') == name
      end

      nil
    end

    def find_or_create_product_attribute_by_name(name)
      product_attributes = get_product_attributes
      attribute_found = nil
      product_attributes.each do |attribute|
        (attribute_found = attribute) if attribute.dig('name') == name
      end

      return attribute_found if attribute_found.present?

      WoocommerceApi.create_product_attribute({ name: name})
    end

    def create_category(category)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/categories?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"

      HTTParty.post( url, body: category )
      # response = HTTParty.post( url, body: category )
      # return if response.success?

      # raise ThirdPartyApiError.new({ url: url, message: response.body }, response.code)
    end

    def create_products_from_list(products_list)
      full_product_list = []
      products_list.each do |product|
        full_product = ZecatArgentinaApi::Products.get_generic_product_by_id(product.dig('id')).dig('generic_product')
        product_hash = ZecatArgentinaApi::Products.fill_product(full_product)
        response = create_product(product_hash)

        full_product_list << { id: response.dig('id'), product: full_product }
      end

      create_product_variations(full_product_list)
      create_product_images(full_product_list)
    end

    def create_product_variations(full_product_list)
      full_product_list.each do |full_product|
        full_product[:product].dig('products').each do |variation|
          product_variation = ZecatArgentinaApi::Products.fill_variation(full_product[:product], variation)
          create_product_variation(full_product[:id], product_variation)
        end
      end
    end

    def create_product_images(full_product_list)
      full_product_list.each do |full_product|
        full_product[:product].dig('images').each_slice(4) do |group|
          update_product(full_product[:id], {images: ZecatArgentinaApi::Products.fill_images_list(group)})
        end
      end
    end

    def create_category_from_list(categories_list)
      categories_list.each do |category|
        create_category(category)
      end
    end
  end
end
