# frozen_string_literal: true

class ProductsCleanupJob
  include Sidekiq::Job
  sidekiq_options queue: :cleanup, unique_for: 20.hours, retry: false

  def perform
    Rails.logger.info 'Running Products Cleanup Job'

    CountrySelection::list.each do |country|
      Object.const_get("#{country}ProductsCleanupJob").perform_async
    end
  end
end
