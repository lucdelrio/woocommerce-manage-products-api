# frozen_string_literal: true

class Product < ApplicationRecord
  rails_admin do
    list do
      exclude_fields :product_hash, :zecat_hash, :created_at, :updated_at
    end

    # update do
    #   field :regular_price
    # end
  end

  before_destroy :remove_from_woocommerce
  after_update :check_variations
  after_create :setup
  # after_update :sync_variations_for_price, if :regular_price_previously_changed?

  private

  def setup
    VariationsSetupJob.perform_in(10.seconds, self.id)
    AttachmentsSetupJob.perform_in(20.seconds, self.id)
  end

  def check_variations
    return unless zecat_hash_previously_changed? && created_at < Time.zone.now - 5.minutes

    setup
  end

  def remove_from_woocommerce
    CountrySelection::woocommerce_class_name(self.country).destroy_product_by_id(self.woocommerce_api_id)
    Variation.where(zecat_product_id: self.zecat_id, country: self.country).destroy_all
    Attachment.where(zecat_product_id: self.zecat_id, country: self.country).destroy_all
  end
end
