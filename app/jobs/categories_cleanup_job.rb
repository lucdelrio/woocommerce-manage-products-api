# frozen_string_literal: true

class CategoriesCleanupJob
  include Sidekiq::Job
  queue_as :categories_cleanup
  sidekiq_options retry: false
  # sidekiq_options queue: 'soon', unique_for: 72.hours

  def perform
    Integration::Common::CategoriesCleanup.new.iterate_categories_and_destroy
  end
end
