# frozen_string_literal: true

class CategoriesCleanupJob
  include Sidekiq::Job

  sidekiq_options queue: :cleanup, unique_for: 20.hours, retry: false

  def perform
    Rails.logger.info 'Running Categories Cleanup Job'

    CountrySelection::list.each do |country|
      Integration::Tools::CategoriesCleanup.new(country).iterate_categories_and_destroy
    end
  end
end
