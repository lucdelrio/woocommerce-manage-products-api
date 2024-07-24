# frozen_string_literal: true

class ProductsUpdatePriceJob
  include Sidekiq::Job
  queue_as :products_iteration
  sidekiq_options retry: false

  def perform
    Integration::Products.iterate_products_and_create
  end
end
