# frozen_string_literal: true

class Category < ApplicationRecord
  before_destroy :remove_from_woocommerce

  private

  def remove_from_woocommerce
    WoocommerceApi.destroy_category_by_id(self.woocommerce_api_id)
  end
end
