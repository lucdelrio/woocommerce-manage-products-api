# frozen_string_literal: true

module EntityGeneration
  class Categories
    class << self
      def fill_categories_hash(categories)
        categories_hash = []

        categories.each do |category|
          categories_hash << category_hash(category)
        end

        categories_hash
      end

      def category_hash(category)
        base_hash = {
          name: category['description'],
          description: category['meta'],
          image: { src: category['icon_url'] }
        }

        return base_hash unless category['url'].present?

        base_hash.merge({ slug: category['url'][1..category['url']&.length] })
      end
    end
  end
end
