# frozen_string_literal: true

module Integration
  class Categories
    def initialize
      @zecat_categories = ZecatApi::Families.categories
      @woocommerces_categories = WoocommerceApi.categories
    end

    def iterate_categories_and_sync
      @zecat_categories.each do |category|
        category_hash = EntityGeneration::Categories.category_hash(category)
        local_category = find_or_create_local_category(category['id'], category_hash)

        sync_category(local_category, category_hash)
      end
    end

    def sync_category(local_category, category_hash)
      local_category.update(last_sync: nil) unless remote_available(local_category)

      if local_category.last_sync.nil?
        woocommerce_category = WoocommerceApi.create_category(category_hash)
        sync_local(local_category, woocommerce_category, category_hash)
      elsif category_hash.to_json != local_category.category_hash.to_json
        woocommerce_category = WoocommerceApi.update_category(local_category.woocommerce_api_id, category_hash)
        sync_local(local_category, woocommerce_category, category_hash)
      else
        local_category.update(last_sync: Time.zone.now)
      end
    end

    def remote_available(local_category)
      return false if local_category.woocommerce_api_id.nil?

      !WoocommerceApi.category_by_id(local_category.woocommerce_api_id).nil?
    end

    def sync_local(local_category, woocommerce_category, category_hash)
      woocommerce_category_id = if woocommerce_category.try(:success?)
                                  woocommerce_category.dig('id')
                                else
                                  JSON.parse(woocommerce_category.body)['data']['resource_id']
                                end

      (local_category.destroy! ; return) unless woocommerce_category_id.present?

      local_category.update(woocommerce_api_id: woocommerce_category_id.to_s,
                              woocommerce_last_updated_at: Time.zone.now,
                              last_sync: Time.zone.now, category_hash: category_hash)
    end

    def find_or_create_local_category(zecat_id, category_hash)
      category_found = Category.find_by(zecat_id: zecat_id.to_i)

      return category_found if category_found.present?

      Category.new(
        name: category_hash[:name],
        description: category_hash[:description],
        zecat_id: zecat_id
      )
    end
  end
end
