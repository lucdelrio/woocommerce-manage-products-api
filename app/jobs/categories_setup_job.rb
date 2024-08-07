# frozen_string_literal: true

class CategoriesSetupJob
  include Sidekiq::Job
  queue_as :categories
  sidekiq_options retry: false

  def perform
    CountrySelection::list.each do |country|
      Integration::Categories.new(country).iterate_categories_and_sync
    end
  end
end
