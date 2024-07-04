# frozen_string_literal: true

class ZecatArgentinaApi
  class Products << BaseZecatArgentinaApi
    class << self
      def get_generic_product
        url = "#{ZECAT_ENDPOINT}/generic_product"
        response = HTTParty.get(url)
        JSON.parse(response.body)
      end

      def get_generic_product_by_page_with_sort(sort_type, sort, page_number, limit)
        url = "#{ZECAT_ENDPOINT}/generic_product?order[#{sort_type}]=#{sort}&page=#{page_number}&limit=#{limit}"
        response = HTTParty.get(url)

        json_products = JSON.parse(response.body)

        fill_products_hash(json_products['generic_products'])
      end

      def get_generic_product_by_family(family_id, page_number, limit)
        url = "#{ZECAT_ENDPOINT}/generic_product?families[]=#{family_id}&page=#{page_number}&limit=#{limit}"
        response = HTTParty.get(url)

        json_products = JSON.parse(response.body)

        fill_products_hash(json_products['generic_products'])
      end


      fill_products_hash(json_products, category_id)

      def fill_products_hash(products, category_id)
        product_hash = []
        products.each do |product|

          product_hash << {
            name: product.name,
            type: "simple",
            price: product.price,
            description: "Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.",
            short_description: "Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.",
            categories: [
              {
                id: category_id
              }
            ],
            images: [
              {
                src: "http://demo.woothemes.com/woocommerce/wp-content/uploads/sites/56/2013/06/T_2_front.jpg"
              },
              {
                src: "http://demo.woothemes.com/woocommerce/wp-content/uploads/sites/56/2013/06/T_2_back.jpg",
              }
            ]
          }
        end
      end
    end
  end
end