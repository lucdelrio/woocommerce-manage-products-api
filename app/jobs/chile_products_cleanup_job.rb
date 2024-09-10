# frozen_string_literal: true

class ChileProductsCleanupJob
  include Sidekiq::Job
  queue_as :cleanup
  sidekiq_options retry: false

  def perform
    # Integration::Tools::ProductsCleanup.iterate_products_and_destroy('Chile')
  end
end
