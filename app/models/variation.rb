# frozen_string_literal: true

class Variation < ApplicationRecord
  rails_admin do
  end

  before_destroy :remove_from_woocommerce

  private

  def remove_from_woocommerce
    WoocommerceApi.destroy_product_variation(self.woocommerce_api_product_id, self.woocommerce_api_id)
  end
end
