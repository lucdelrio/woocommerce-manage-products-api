# frozen_string_literal: true

class ZecatChileApi
  ZECAT_ENDPOINT = 'https://api.zecat.cl'.freeze


  class << self
    def get_generic_product
      url = "#{ZECAT_ENDPOINT}/generic_product"
      response = HTTParty.get(url)
    end

    def get_generic_product_by_page_with_sort(sort_type, sort, page_number, limit)
      url = "#{ZECAT_ENDPOINT}/generic_product?order[#{sort_type}]=#{sort}&page=#{page_number}"
      response = HTTParty.get(url)
    end
  end
end
