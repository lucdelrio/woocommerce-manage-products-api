# frozen_string_literal: true

class Variation < ApplicationRecord
  rails_admin do
    list do
      exclude_fields :variation_hash, :created_at, :updated_at
    end
  end

  before_destroy :remove_from_woocommerce
  after_update :update_product_price if :variation_hash_previously_changed?

  private

  def remove_from_woocommerce
    CountrySelection::woocommerce_class_name(self.country).destroy_product_variation(self.woocommerce_api_product_id, self.woocommerce_api_id)
  end

  def update_product_price
    product = Product.find_by(zecat_id: self.zecat_product_id, country: self.country)
    product.update(regular_price: self.regular_price)
  end
end
