# frozen_string_literal: true

class ProductsIterationJob
  include Sidekiq::Job
  queue_as :products_iteration
  sidekiq_options retry: false

  def perform
    Integration::Argentina::Products.iterate_products_and_create
  end
end
