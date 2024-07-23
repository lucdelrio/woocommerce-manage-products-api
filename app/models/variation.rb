# frozen_string_literal: true

class Variation < ApplicationRecord
  rails_admin do
  end

  before_destroy :remove_from_woocommerce
  after_update :update_product_price

  private

  def remove_from_woocommerce
    WoocommerceApi.destroy_product_variation(self.woocommerce_api_product_id, self.woocommerce_api_id)
  end

  def update_product_price
    return unless regular_price_changed?
    
    product = Product.find_by(zecat_id: self.zecat_product_id)
    product.update(regular_price: self.regular_price)
  end
end
