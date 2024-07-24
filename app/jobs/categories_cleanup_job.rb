# frozen_string_literal: true

class CategoriesCleanupJob
  include Sidekiq::Job

  sidekiq_options queue: :cleanup, unique_for: 20.hours, retry: false

  def perform
    Rails.logger.info 'Running Categories Cleanup Job'

    Integration::Tools::CategoriesCleanup.new.iterate_categories_and_destroy
  end
end
