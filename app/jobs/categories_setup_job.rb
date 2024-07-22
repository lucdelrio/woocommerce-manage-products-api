# frozen_string_literal: true

class CategoriesSetupJob
  include Sidekiq::Job
  queue_as :categories
  sidekiq_options retry: false
  # sidekiq_options queue: 'soon', unique_for: 72.hours

  def perform
    Integration::Argentina::Categories.new.iterate_categories_and_sync
  end
end
