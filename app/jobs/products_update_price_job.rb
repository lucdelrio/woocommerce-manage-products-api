# frozen_string_literal: true

class ProductsUpdatePriceJob
  include Sidekiq::Job
  queue_as :products_iteration
  sidekiq_options retry: false

  def perform
    CountrySelection::list.each do |country|
      Integration::Products.new(country).iterate_products_and_create
    end
  end
end
