require "woocommerce/version"
require 'httparty'

module Woocommerce
  class API
    include HTTParty

    # Default timeout of 3 seconds
    DEFAULT_TIMEOUT = 180

    API_ENDPOINT = '/wc-api/v2/'

    # Default headers for HTTP requests
    DEFAULT_HEADERS = {
        'User-Agent' => "WooCommerce gem #{Woocommerce::VERSION}",

    }

    attr_accessor :consumer_key, :consumer_secret

    format(:json)
    headers(DEFAULT_HEADERS)
    default_timeout(DEFAULT_TIMEOUT)

    def initialize(consumer_key, consumer_secret, store_url)
      if consumer_key and consumer_secret and store_url and store_url.start_with?('https')
        @consumer_key = consumer_key
        @consumer_secret = consumer_secret
        self.class.base_uri store_url + API_ENDPOINT
        self.class.default_params consumer_key: @consumer_key
        self.class.default_params consumer_secret: @consumer_secret
      else
        raise 'We need all arguments, and store_url must start with https'
      end
    end

    # Turn on HTTParty debugging
    #
    # @param location [Object] Output "sink" for HTTP debugging
    def debug(location = $stderr)
      self.class.debug_output(location)
    end

    def set_http_headers(http_headers = {})
      http_headers.merge!(DEFAULT_HEADERS)
      self.class.headers(http_headers)
    end

    def set_timeout(timeout)
      self.class.default_timeout(timeout)
    end

    def get_products(per_page = 10, page = 1)
      options = {
          filter: {limit: per_page},
          page: page
      }
      endpoint = woocommerce_api_url_for('products')
      self.class.get(endpoint, query: options).parsed_response
    end

    def get_products_count
      endpoint = woocommerce_api_url_for('products/count')
      self.class.get(endpoint).parsed_response
    end

    def get_product(product_id)
      endpoint = woocommerce_api_url_for("products/#{product_id}")
      self.class.get(endpoint).parsed_response
    end

    def woocommerce_api_url_for(method)
      "#{self.class.base_uri}/#{method}"
    end

  end
end
