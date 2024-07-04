# frozen_string_literal: true

class WoocommerceApi
  WOOCOMMERCE_ENDPOINT = ENV.fetch('WOOCOMMERCE_ENDPOINT')
  CONSUMER_KEY = ENV.fetch('WOOCOMMERCE_CONSUMER_KEY')
  CONSUMER_SECRET = ENV.fetch('WOOCOMMERCE_CONSUMER_SECRET')

  class << self

    def get_products
      url = "#{WOOCOMMERCE_ENDPOINT}/products?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"
      response = HTTParty.get(url)
    end

    def get_categories
      url = "#{WOOCOMMERCE_ENDPOINT}/products/categories?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"
      response = HTTParty.get(url)
    end

    def create_product(products_list)
      url = "#{WOOCOMMERCE_ENDPOINT}/products?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"
      
      response = HTTParty.post(url,
                                body: {
                                  subscribed_fields: SUBSCRIBED_FIELDS,
                                  access_token: access_token
                                })
      return if response.success?

      raise ThirdPartyApiError.new({ url: url, message: response.body }, response.code)
    end

    def create_category(category)
      url = "#{WOOCOMMERCE_ENDPOINT}/products/categories?consumer_key=#{CONSUMER_KEY}&consumer_secret=#{CONSUMER_SECRET}"

      HTTParty.post( url, body: category )
      # response = HTTParty.post( url, body: category )
      # return if response.success?

      # raise ThirdPartyApiError.new({ url: url, message: response.body }, response.code)
    end

    def create_category_from_list(categories_list)
      categories_list.each do |category|
        create_category(category)
      end
    end
  end
end
#   def initialize
#     woocommerce = WooCommerce::API.new(
#       "https://pruebas.weblocal.top",
#       "ck_c44ea9194b24a367c9f1d43f5eb3b6602932323a",
#       "cs_f8271c29ca83f6b4e692fc879234f90bd8b35820",
#       {
#         wp_api: true,
#         wp_json: true,
#         version: "v3"
#       }
#     )
#   end

#   woocommerce = WooCommerce::API.new(
#     "https://pruebas.weblocal.top/",
#     "ck_c44ea9194b24a367c9f1d43f5eb3b6602932323a",
#     "cs_f8271c29ca83f6b4e692fc879234f90bd8b35820",
#     {
#       wp_api: true,
#       wp_json: true,
#       version: "v3"
#     }
#   )

