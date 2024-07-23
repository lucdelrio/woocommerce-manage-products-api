# frozen_string_literal: true

class AttachmentsSetupJob
  include Sidekiq::Job
  queue_as :attachments
  sidekiq_options retry: false

  def perform(product_id)
    product = Product.find product_id

    Integration::Argentina::Attachments.create_product_media(product.woocommerce_api_id, product.zecat_hash)
  end
end
