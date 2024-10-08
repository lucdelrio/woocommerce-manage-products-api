# frozen_string_literal: true

class ProductSetupJob
  include Sidekiq::Job
  queue_as :products
  sidekiq_options retry: false

  def perform(zecat_product_id, zecat_country)
    Integration::Products.new(zecat_country).create_or_sync_product(zecat_product_id)
  end
end
