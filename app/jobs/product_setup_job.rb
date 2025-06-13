# frozen_string_literal: true

class ProductSetupJob
  include Sidekiq::Job
  queue_as :products
  sidekiq_options retry: false

  def perform(zecat_product_id, zecat_country)
    ZecatSync::ProductSync.new(zecat_product_id, zecat_country).sync_product
  end
end
