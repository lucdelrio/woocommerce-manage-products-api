# frozen_string_literal: true

module ZecatArgentinaApi
  class Families < ZecatArgentinaApi::Base
    class << self
      def get_categories
        url = "#{ZECAT_ENDPOINT}/family"
        response = HTTParty.get(url)
        JSON.parse(response.body).dig('families')
      end

      def get_category_by_description(description)
        categories = get_categories
        categories.each do |category|
          return category if category.dig('description') == description
        end

        nil
      end

      def fill_categories_hash(categories)
        categories_hash = []

        categories.each do |category|
          categories_hash << category_hash(category)
        end

        categories_hash
      end

      def category_hash(category)
        {
          :name => category.dig('title'),
          :description => category.dig('description'),
          :slug => category.dig('url')[1..category['url'].length],
          # :image => {
          #   :src => category['icon_url']
          # }
        }
      end

      ## Imagen INVALIDA
      #<HTTParty::Response:0x6900 parsed_response={"code"=>"woocommerce_rest_invalid_image", "message"=>"Imagen no válida: Lo siento, no tienes permisos para subir este tipo de archivo.", "data"=>{"status"=>400}}, @response=#<Net::HTTPBadRequest 400 Bad Request readbody=true>, @headers={"connection"=>["close"], "x-powered-by"=>["PHP/8.1.27"], "set-cookie"=>["request_a_quote_user_coockie=6685a7629c77f; secure"], "content-type"=>["application/json; charset=UTF-8"], "x-robots-tag"=>["noindex"], "link"=>["<https://pruebas.weblocal.top/wp-json/>; rel=\"https://api.w.org/\""], "x-content-type-options"=>["nosniff"], "access-control-expose-headers"=>["X-WP-Total, X-WP-TotalPages, Link"], "access-control-allow-headers"=>["Authorization, X-WP-Nonce, Content-Disposition, Content-MD5, Content-Type"], "allow"=>["GET, POST"], "expires"=>["Wed, 11 Jan 1984 05:00:00 GMT"], "cache-control"=>["no-cache, must-revalidate, max-age=0, no-store, private"], "content-length"=>["146"], "vary"=>["Accept-Encoding"], "date"=>["Wed, 03 Jul 2024 19:32:51 GMT"], "server"=>["LiteSpeed"], "platform"=>["hostinger"], "content-security-policy"=>["upgrade-insecure-requests"], "alt-svc"=>["h3=\":443\"; ma=2592000, h3-29=\":443\"; ma=2592000, h3-Q050=\":443\"; ma=2592000, h3-Q046=\":443\"; ma=2592000, h3-Q043=\":443\"; ma=2592000, quic=\":443\"; ma=2592000; v=\"43,46\""]}>
    end
  end
end
