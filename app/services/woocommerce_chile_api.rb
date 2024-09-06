# frozen_string_literal: true

class WoocommerceChileApi
  WOOCOMMERCE_ENDPOINT = ENV.fetch('WOOCOMMERCE_CHILE_ENDPOINT')
  CONSUMER_KEY = ENV.fetch('CHILE_WOOCOMMERCE_CONSUMER_KEY')
  CONSUMER_SECRET = ENV.fetch('CHILE_WOOCOMMERCE_CONSUMER_SECRET')
  CONSUMER_KEY_AND_CONSUMER_SECRET = "consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"

  # rubocop:disable Layout/LineLength
  class << self
    def get_products
      url = "#{WOOCOMMERCE_ENDPOINT}/products?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      response = HTTParty.get(url)
      JSON.parse(response.body)
    end

    def product_by_id(id)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/#{id.to_s}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      response = HTTParty.get(url)
      JSON.parse(response.body)
    end

    def destroy_product_by_id(id)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/#{id.to_s}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      response = HTTParty.delete(url)
      JSON.parse(response.body)
    end

    def get_products_by_category_id(category_id, page)
      url = "#{WOOCOMMERCE_ENDPOINT}/products?category=#{category_id.to_s}&page=#{page}&#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
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
      url = "#{WOOCOMMERCE_ENDPOINT}/products/categories/#{id.to_s}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      response = HTTParty.get(url)
      JSON.parse(response.body)
    end

    def destroy_category_by_id(id)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/categories/#{id.to_s}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
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

      Rails.logger.info 'Create Woocommerce Product'
      JSON.parse(response.body)
    end

    def update_product(id, product)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/#{id.to_s}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      Rails.logger.info 'Update Woocommerce Product'
      HTTParty.put(url, body: product.to_json, headers: { 'Content-Type': 'application/json' }, timeout: 120)
    end

    def create_product_variation(product_id, variation)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/#{product_id.to_s}/variations?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      HTTParty.post(url, body: variation.to_json, headers: { 'Content-Type': 'application/json' })
    end

    def update_product_variation(product_id, variation_id, variation)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/#{product_id.to_s}/variations/#{variation_id.to_s}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      HTTParty.post(url, body: variation.to_json, headers: { 'Content-Type': 'application/json' })
    end

    def destroy_product_variation(product_id, variation_id)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/#{product_id.to_s}/variations/#{variation_id.to_s}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      response = HTTParty.delete(url)
      JSON.parse(response.body)
    end

    def create_product_attribute(attribute)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/attributes?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"

      response = HTTParty.post(url, body: attribute)
      JSON.parse(response.body)
    end

    def create_product_attribute_term(attribute_id, attribute)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/attributes/#{attribute_id.to_s}/terms?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"

      response = HTTParty.post(url, body: attribute)
      JSON.parse(response.body)
    end

    def get_product_attribute_terms_by_attribute_id(attribute_id)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/attributes/#{attribute_id.to_s}/terms?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"

      response = HTTParty.get(url)
      JSON.parse(response.body)
    end

    def get_product_attribute_terms_by_attribute_id_and_term_id(attribute_id, term_id)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/attributes/#{attribute_id.to_s}/terms/#{term_id.to_s}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"

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

      HTTParty.post(url, body: category.to_json, headers: { 'Content-Type': 'application/json' })
    end

    def update_category(id, category)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/categories/#{id.to_s}?#{CONSUMER_KEY_AND_CONSUMER_SECRET}"
      HTTParty.put(url, body: category.to_json, headers: { 'Content-Type': 'application/json' })
    end

    def create_category_from_list(categories_list)
      categories_list.each do |category|
        create_category(category)
      end
    end
  end
  # rubocop:enable Layout/LineLength
end
