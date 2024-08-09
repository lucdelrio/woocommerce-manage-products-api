# frozen_string_literal: true

class ProductsCleanupJob
  include Sidekiq::Job
  sidekiq_options queue: :cleanup, unique_for: 20.hours, retry: false

  def perform(zecat_country)
    Rails.logger.info 'Running Products Cleanup Job'

    CountrySelection::list.each do |country|
      Integration::Tools::ProductsCleanup.iterate_products_and_destroy(country)
    end
  end
end
