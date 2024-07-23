# frozen_string_literal: true

class ProductsCleanupJob
  include Sidekiq::Job
  sidekiq_options queue: :products_cleanup, unique_for: 20.hours, retry: false

  def perform
    Integration::Common::ProductsCleanup.iterate_products_and_destroy
  end
end
