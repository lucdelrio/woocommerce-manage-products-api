# frozen_string_literal: true

module ZecatChileApi
  class Products < ZecatChileApi::Base
    class << self
      def get_generic_product
        url = "#{ZECAT_ENDPOINT}/generic_product"
        response = HTTParty.get(url, headers: BEARER_TOKEN_AUTHORIZATION, timeout: 120)
        JSON.parse(response.body)
      end

      def generic_product_by_id(product_id)
        url = "#{ZECAT_ENDPOINT}/generic_product/#{product_id}"
        response = HTTParty.get(url, headers: BEARER_TOKEN_AUTHORIZATION, timeout: 120, verify: true)
        JSON.parse(response.body)
      end

      def get_generic_product_by_page_with_sort(sort_type, sort, page_number, limit)
        url = "#{ZECAT_ENDPOINT}/generic_product?order[#{sort_type}]=#{sort}&page=#{page_number}&limit=#{limit}"
        response = HTTParty.get(url, headers: BEARER_TOKEN_AUTHORIZATION, timeout: 120)

        JSON.parse(response.body)
      end

      def get_generic_product_by_page(page_number, limit)
        url = "#{ZECAT_ENDPOINT}/generic_product?page=#{page_number}&limit=#{limit}"
        response = HTTParty.get(url, headers: BEARER_TOKEN_AUTHORIZATION, timeout: 120)

        JSON.parse(response.body)
      end

      # Generic Variant
      # product_list = ZecatChileApi::Products.get_generic_product_by_family_with_pages('64', '2', '5')
      # list = product_list.dig('generic_products')
      # Ropa
      # ZecatChileApi::Products.get_generic_product_by_family_with_pages('128', '1', '5')
      def get_generic_product_by_family_with_pages(family_id, page_number, limit)
        url = "#{ZECAT_ENDPOINT}/generic_product?families[]=#{family_id}&page=#{page_number}&limit=#{limit}"
        response = HTTParty.get(url, headers: BEARER_TOKEN_AUTHORIZATION, timeout: 120)

        JSON.parse(response.body)
      end
    end
  end
end
