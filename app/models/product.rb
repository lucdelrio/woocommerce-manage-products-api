# frozen_string_literal: true

class Product < ApplicationRecord
  rails_admin do
  end

  before_destroy :remove_from_woocommerce
  after_update :check_variations
  after_update :setup

  private

  def setup
    return unless created_at > Time.zone.now - 5.minutes

    VariationsSetupJob.perform_async(self.id)
    AttachmentsSetupJob.perform_async(self.id)
  end

  def check_variations
    return unless zecat_hash_changed? && created_at < Time.zone.now - 5.minutes

    Integration::Argentina::Variations.create_product_variations(self.woocommerce_api_id, self.zecat_hash)
    Integration::Argentina::Attachments.create_product_media(self.woocommerce_api_id, self.zecat_hash)
  end

  def remove_from_woocommerce
    WoocommerceApi.destroy_product_by_id(self.woocommerce_api_id)
    Variation.where(zecat_product_id: self.zecat_id).destroy_all
    Attachment.where(zecat_product_id: self.zecat_id).destroy_all
  end
end
