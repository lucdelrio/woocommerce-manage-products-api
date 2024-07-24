# frozen_string_literal: true

class AttachmentsSetupJob
  include Sidekiq::Job
  queue_as :attachments
  sidekiq_options retry: 5, unique: :until_executed

  def perform(product_id)
    product = Product.find product_id

    Integration::Attachments.create_product_media(product.woocommerce_api_id, product.zecat_hash)
  end
end
