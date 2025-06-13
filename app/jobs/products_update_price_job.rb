# frozen_string_literal: true

class ProductsUpdatePriceJob
  include Sidekiq::Job
  queue_as :products_iteration
  sidekiq_options retry: false

  def perform
    CountrySelection::list.each do |country|
      Product.where(country: country).find_each do |product|
        ProductSetupJob.perform_in(20.seconds, product.zecat_id, country)
      end
    end
  end
end
