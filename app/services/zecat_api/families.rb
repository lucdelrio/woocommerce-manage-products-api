# frozen_string_literal: true

module ZecatApi
  class Families < ZecatApi::Base
    class << self
      def categories
        url = "#{ZECAT_ENDPOINT}/family"
        response = HTTParty.get(url)
        JSON.parse(response.body)['families']
      end

      def category_by_description(categories, description)
        categories.each do |category|
          return category if category['description'] == description
        end

        nil
      end

      def category_by_name(categories, name)
        categories.each do |category|
          return category if category['title'] == name
        end

        nil
      end

      def category_by_id(categories, id)
        categories.each do |category|
          return category if category['id'] == id
        end

        nil
      end
    end
  end
end
