# frozen_string_literal: true

class ProductSetupJob
  include Sidekiq::Job
  queue_as :products
  sidekiq_options retry: false

  def perform(zecat_product_id)
    Integration::Argentina::Products.create_or_sync_product(zecat_product_id)
  end
end
