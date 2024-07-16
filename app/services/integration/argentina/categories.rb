# frozen_string_literal: true
module Integration
  module Argentina
    class Categories
      class << self
        def iterate_categories_and_sync
          categories = ZecatArgentinaApi::Families.get_categories

          categories.each do |category|
            category_hash = ZecatArgentinaApi::Families.category_hash(category)
            local_category = find_or_create_local_category(category['id'], category_hash)

            if local_category.last_sync.nil?
              woocommerce_category = WoocommerceApi.create_category(category_hash)
              sync_local(local_category, woocommerce_category, category_hash)
            else
              if category_hash.to_json != local_category.category_hash.to_json
                woocommerce_category = WoocommerceApi.update_category(category['id'], category_hash)
                sync_local(local_category, woocommerce_category, category_hash)
              else
                local_category.update(last_sync: Time.now)
              end
            end            
          end
        end

        def sync_local(local_category, woocommerce_category, category_hash)
          local_category.update(woocommerce_api_id: woocommerce_category.dig('id').to_s, woocommerce_last_updated_at: Time.now,
                                last_sync: Time.now, category_hash: category_hash)
        end

        def find_or_create_local_category(zecat_id, category_hash)
          category_found = Category.find_by(zecat_id: zecat_id)

          return category_found if category_found.present?

          Category.create!(
            name: category_hash[:name],
            description: category_hash[:description],
            zecat_id: zecat_id
            # category_hash: category_hash
          )
        end
      end
    end
  end
end