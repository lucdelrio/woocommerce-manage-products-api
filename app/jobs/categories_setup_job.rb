# frozen_string_literal: true

class CategoriesSetupJob
  include Sidekiq::Job
  queue_as :categories
  sidekiq_options retry: false

  def perform
    Integration::Categories.new.iterate_categories_and_sync
  end
end
