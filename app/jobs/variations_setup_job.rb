# frozen_string_literal: true

class VariationsSetupJob
  include Sidekiq::Job
  queue_as :variations
  sidekiq_options retry: false

  def perform(product_id)
    product = Product.find product_id
    return if product.nil?

    Integration::Variations.new(product.country).create_product_variations(product.woocommerce_api_id, product.zecat_hash)
  end
end
