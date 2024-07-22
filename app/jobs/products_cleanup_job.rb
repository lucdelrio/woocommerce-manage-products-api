# frozen_string_literal: true

class ProductsCleanupJob
  include Sidekiq::Job
  queue_as :products_cleanup
  sidekiq_options retry: false
  # sidekiq_options queue: 'soon', unique_for: 72.hours

  def perform
    Integration::Common::ProductsCleanup.new.iterate_products_and_destroy
  end
end
