# frozen_string_literal: true

class ChileCategoriesCleanupJob
  include Sidekiq::Job

  sidekiq_options queue: :cleanup, unique_for: 20.hours, retry: false

  def perform
    Rails.logger.info 'Running Categories Cleanup Job'

    Integration::Tools::CategoriesCleanup.new('Chile').iterate_categories_and_destroy
  end
end
