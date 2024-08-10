# frozen_string_literal: true

class ProductCustomizationJob
  include Sidekiq::Job
  queue_as :product_customizations
  sidekiq_options retry: false

  def perform
    Integration::ProductCustomizations.iterate_products_and_create_customization
  end
end
