# frozen_string_literal: true
module Integration
  module Argentina
    class Categories
      class << self
        def iterate_categories_and_sync

        end

        def sync_local(local_category, woocommerce_category, category_hash)
          local_category.update(woocommerce_api_id: woocommerce_category.dig('id').to_s, woocommerce_last_updated_at: Time.now,
                                last_sync: Time.now, category_hash: category_hash)
        end

        def find_or_create_local_category(zecat_id, category_hash)

        end
      end
    end
  end
end