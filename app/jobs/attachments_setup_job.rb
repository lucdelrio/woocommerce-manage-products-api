# frozen_string_literal: true

class AttachmentsSetupJob
  include Sidekiq::Job
  queue_as :attachments
  sidekiq_options retry: false

  def perform(product_id)
    product = Product.find product_id
    Integration::Argentina::Attachments.create_media_for_product(product)
  end
end
