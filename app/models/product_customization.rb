# frozen_string_literal: true

class ProductCustomization < ApplicationRecord
  rails_admin do
    list do
      exclude_fields :last_sync, :woocommerce_api_id, :product_id, :country, :created_at, :updated_at
      include_fields :id, :zecat_product_id, :woocommerce_api_id, :minimum_application_quantity,
                     :setup_price, :product_id, :country, :updated_at
    end
  end

  after_create :send_customization_email
  # after_update :send_customization_email, if: :saved_change_to_minimum_application_quantity?

  private

  def send_customization_email
    ProductCustomizationMailJob.perform_async(self.id)
  end
end
