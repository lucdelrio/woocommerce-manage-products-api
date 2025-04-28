# frozen_string_literal: true

module Integration
  class Categories
    def initialize(zecat_country)
      @zecat_country = zecat_country
      @zecat_categories = CountrySelection.zecat_class_name(zecat_country)::Families.categories
    end

    def iterate_categories_and_sync
      @zecat_categories.each do |category|
        category_hash = EntityGeneration::Categories.category_hash(category)
        next if category['show'] == false

        local_category = find_or_create_local_category(category['id'], category_hash)

        sync_category(local_category, category_hash)
      end
    end

    def sync_category(local_category, category_hash)
      local_category.update(last_sync: nil) unless remote_available(local_category)

      if local_category.woocommerce_api_id.nil?
        woocommerce_category = CountrySelection.woocommerce_class_name(@zecat_country).create_category(category_hash)
        sync_local(local_category, woocommerce_category, category_hash)
      elsif category_hash.to_json != local_category.category_hash.to_json
        woocommerce_category = CountrySelection.woocommerce_class_name(@zecat_country).update_category(
          local_category.woocommerce_api_id, category_hash
        )
        sync_local(local_category, woocommerce_category, category_hash)
      end
    end

    def remote_available(local_category)
      return false if local_category.woocommerce_api_id.nil?

      !CountrySelection.woocommerce_class_name(@zecat_country).category_by_id(local_category.woocommerce_api_id).nil?
    end

    def sync_local(local_category, woocommerce_category, category_hash)
      woocommerce_category_id = if woocommerce_category.try(:success?)
                                  woocommerce_category['id']
                                else
                                  JSON.parse(woocommerce_category.body).dig('data',
                                                                            'resource_id') || woocommerce_category['id']
                                end

      unless woocommerce_category_id.present?
        (local_category.destroy!
         return)
      end

      local_category.update(woocommerce_api_id: woocommerce_category_id.to_s,
                            woocommerce_last_updated_at: Time.zone.now,
                            last_sync: Time.zone.now, category_hash: category_hash)
    end

    def find_or_create_local_category(zecat_id, category_hash)
      category_found = Category.find_by(zecat_id: zecat_id.to_i, country: @zecat_country)

      return category_found if category_found.present?

      Category.new(
        name: category_hash[:name],
        description: category_hash[:description],
        zecat_id: zecat_id,
        country: @zecat_country
      )
    end
  end
end
