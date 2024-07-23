# frozen_string_literal: true

class CategoriesCleanupJob
  include Sidekiq::Job

  sidekiq_options queue: :categories_cleanup, unique_for: 20.hours, retry: false

  def perform
    Integration::Common::CategoriesCleanup.new.iterate_categories_and_destroy
  end
end
