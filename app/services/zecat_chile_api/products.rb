# frozen_string_literal: true

module ZecatChileApi
  class Products < ZecatChileApi::Base
    class << self
      def get_generic_product
        url = "#{ZECAT_ENDPOINT}/generic_product"
        HTTParty.get(url)
      end

      def get_generic_product_by_page_with_sort(sort_type, sort, page_number, _limit)
        url = "#{ZECAT_ENDPOINT}/generic_product?order[#{sort_type}]=#{sort}&page=#{page_number}"
        HTTParty.get(url)
      end
    end
  end
end
