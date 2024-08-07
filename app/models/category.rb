# frozen_string_literal: true

class Category < ApplicationRecord
  rails_admin do
    list do
      exclude_fields :category_hash, :created_at, :updated_at
    end
  end

  before_destroy :remove_from_woocommerce

  private

  def remove_from_woocommerce
    CountrySelection::woocommerce_class_name(zecat_country).destroy_category_by_id(self.woocommerce_api_id)
  end
end
