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

    def create_product_with_variations(product)
      product_hash = ZecatArgentinaApi::Products.fill_product(product)
      response = create_product(product_hash)
      product.dig('products').each do |variation|
        product_variation = ZecatArgentinaApi::Products.fill_variation(product, variation)
        create_product_variation(response.dig('id'), product_variation)
      end

      response
    end

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
      puts JSON.parse(response.body)
    end

    def create_product_attribute_term(attribute_id, attribute)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/attributes/#{attribute_id}/terms?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"

      response = HTTParty.post( url, body: attribute )
      puts 'create_product_attribute_term'
      puts JSON.parse(response.body)
      JSON.parse(response.body)
    end

    def get_product_attribute_terms_by_attribute_id(attribute_id)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/attributes/#{attribute_id}/terms?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"

      response = HTTParty.get( url)
      JSON.parse(response.body)
    end

    def get_term_by_name(term_list, name)
      term_list.each do |term|
        return term if term.dig('name') == name
      end

      nil
    end

    def create_category(category)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/categories?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"

      HTTParty.post( url, body: category )
      # response = HTTParty.post( url, body: category )
      # return if response.success?

      # raise ThirdPartyApiError.new({ url: url, message: response.body }, response.code)
    end

    def create_products_from_list(products_list)
      products_list.each do |product|
        create_product_with_variations(product)
      end
    end

    def create_category_from_list(categories_list)
      categories_list.each do |category|
        create_category(category)
      end
    end
  end
end
