# frozen_string_literal: true

class Product < ApplicationRecord
  rails_admin do
  end

  before_destroy :remove_from_woocommerce
  after_update :check_variations

  private

  def check_variations
    return unless full_product_changed?

    Integration::Argentina::Variation.create_product_variations(self.woocommerce_api_id, self.full_product)
    Integration::Argentina::Attachment.create_product_media(self.woocommerce_api_id, self.full_product)
  end

  def remove_from_woocommerce
    WoocommerceApi.destroy_product_by_id(self.woocommerce_api_id)
    Variation.where(zecat_product_id: self.zecat_id).destroy_all
    Attachment.where(zecat_product_id: self.zecat_id).destroy_all
  end
end
