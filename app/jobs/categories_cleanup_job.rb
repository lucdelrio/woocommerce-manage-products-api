# frozen_string_literal: true

class CategoriesCleanupJob
  include Sidekiq::Job

  sidekiq_options queue: :cleanup, unique_for: 20.hours, retry: false

  def perform
    Integration::Tools::CategoriesCleanup.new.iterate_categories_and_destroy
  end
end
