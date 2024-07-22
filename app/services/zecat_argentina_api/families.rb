# frozen_string_literal: true

module ZecatArgentinaApi
  class Families < ZecatArgentinaApi::Base
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

      def fill_categories_hash(categories)
        categories_hash = []

        categories.each do |category|
          categories_hash << category_hash(category)
        end

        categories_hash
      end

      def category_hash(category)
        {
          name: category['description'],
          description: category['name'],
          slug: category['url'][1..category['url'].length],
          image: {  src: category['icon_url'] }
        }
      end
    end
  end
end
