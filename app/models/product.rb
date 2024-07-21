# frozen_string_literal: true

class Product < ApplicationRecord
  rails_admin do
  end

  before_destroy :remove_from_woocommerce

  private

  def remove_from_woocommerce
    WoocommerceApi.destroy_product_by_id(self.woocommerce_api_id)
    Variation.where(zecat_product_id: self.zecat_id).destroy_all
    Attachment.where(zecat_product_id: self.zecat_id).destroy_all
  end
end
