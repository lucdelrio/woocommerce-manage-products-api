# frozen_string_literal: true

class WoocommerceApi
  WOOCOMMERCE_ENDPOINT = ENV.fetch('WOOCOMMERCE_ENDPOINT')
  CONSUMER_KEY = ENV.fetch('WOOCOMMERCE_CONSUMER_KEY')
  CONSUMER_SECRET = ENV.fetch('WOOCOMMERCE_CONSUMER_SECRET')
  CONSUMER_KEY_AND_CONSUMER_SECRET = "consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"

  # rubocop:disable Layout/LineLength
  class << self
    def get_products
      url = "#{WOOCOMMERCE_ENDPOINT}/products?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      response = HTTParty.get(url)
      JSON.parse(response.body)
    end

    def product_by_id(id)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/#{id}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      response = HTTParty.get(url)
      JSON.parse(response.body)
    end

    def destroy_product_by_id(id)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/#{id}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      response = HTTParty.delete(url)
      JSON.parse(response.body)
    end

    def get_products_by_category_id(category_id, page)
      url = "#{WOOCOMMERCE_ENDPOINT}/products?category=#{category_id}&page=#{page}&#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      response = HTTParty.get(url)
      JSON.parse(response.body)
    end

    def get_product_attributes
      url = "#{WOOCOMMERCE_ENDPOINT}/products/attributes?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      response = HTTParty.get(url)
      JSON.parse(response.body)
    end

    def categories
      url = "#{WOOCOMMERCE_ENDPOINT}/products/categories?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      response = HTTParty.get(url)
      JSON.parse(response.body)
    end

    def category_by_id(id)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/categories/#{id}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      response = HTTParty.get(url)
      JSON.parse(response.body)
    end

    def destroy_category_by_id(id)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/categories/#{id}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      response = HTTParty.delete(url)
      JSON.parse(response.body)
    end

    def category_by_name(categories, name)
      categories.each do |category|
        return category if category['name'] == name
      end

      nil
    end

    def category_by_description(categories, description)
      categories.each do |category|
        return category if category['description'] == description
      end

      nil
    end

    def create_product(product)
      url = "#{WOOCOMMERCE_ENDPOINT}/products?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      response = HTTParty.post(url, body: product.to_json, headers: { 'Content-Type' => 'application/json' })

      Rails.logger.debug 'Create Product'
      Rails.logger.debug JSON.parse(response.body)
      JSON.parse(response.body)

      # return if response.success?

      # raise ThirdPartyApiError.new({ url: url, message: response.body }, response.code)
    end

    def update_product(id, product)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/#{id}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      response = HTTParty.put(url, body: product.to_json, headers: { 'Content-Type': 'application/json' })
      Rails.logger.debug 'Update Product'
      Rails.logger.debug JSON.parse(response.body)
      JSON.parse(response.body)

      # return if response.success?

      # raise ThirdPartyApiError.new({ url: url, message: response.body }, response.code)
    end

    def create_product_variation(product_id, variation)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/#{product_id}/variations?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      HTTParty.post(url, body: variation.to_json, headers: { 'Content-Type': 'application/json' })
    end

    def update_product_variation(product_id, variation_id, variation)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/#{product_id}/variations/#{variation_id}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      HTTParty.post(url, body: variation.to_json, headers: { 'Content-Type': 'application/json' })
    end

    def create_product_attribute(attribute)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/attributes?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"

      response = HTTParty.post(url, body: attribute)
      JSON.parse(response.body)
    end

    def find_or_create_product_attribute_by_name(name)
      product_attribute = ProductAttribute.find_by(name: name)

      return product_attribute if product_attribute.present?

      woocommerce_product_attribute = create_product_attribute({ name: name })

      ProductAttribute.create(name: name, woocommerce_api_id: woocommerce_product_attribute['id'],
                              last_sync: Time.zone.now, woocommerce_last_updated_at: Time.zone.now)
    end

    def create_product_attribute_term(attribute_id, attribute)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/attributes/#{attribute_id}/terms?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"

      response = HTTParty.post(url, body: attribute)
      JSON.parse(response.body)
    end

    def get_product_attribute_terms_by_attribute_id(attribute_id)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/attributes/#{attribute_id}/terms?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"

      response = HTTParty.get(url)
      JSON.parse(response.body)
    end

    def get_product_attribute_terms_by_attribute_id_and_term_id(attribute_id, term_id)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/attributes/#{attribute_id}/terms/#{term_id}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"

      response = HTTParty.get(url)
      JSON.parse(response.body)
    end

    def get_term_by_name(term_list, name)
      term_list.each do |term|
        return term if term['name'] == name
      end

      nil
    end

    def create_category(category)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/categories?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"

      HTTParty.post(url, body: category)
      # response = HTTParty.post( url, body: category )
      # return if response.success?

      # raise ThirdPartyApiError.new({ url: url, message: response.body }, response.code)
    end

    def update_category(id, category)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/categories/#{id}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      response = HTTParty.put(url, body: category.to_json, headers: { 'Content-Type': 'application/json' })
      Rails.logger.debug 'Category body'
      Rails.logger.debug category
      Rails.logger.debug 'Update Category'
      Rails.logger.debug JSON.parse(response.body)
      JSON.parse(response.body)
    end

    def create_category_from_list(categories_list)
      categories_list.each do |category|
        create_category(category)
      end
    end
  end
  # rubocop:enable Layout/LineLength
end
