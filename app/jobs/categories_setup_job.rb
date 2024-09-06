# frozen_string_literal: true

class CategoriesSetupJob
  include Sidekiq::Job
  queue_as :categories
  sidekiq_options retry: false

  def perform
    CountrySelection::list.each do |country|
      Object.const_get("#{country}CategoriesSetupJob").perform_async
    end
  end
end
