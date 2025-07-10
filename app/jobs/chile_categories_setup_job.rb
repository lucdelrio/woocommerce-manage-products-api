# frozen_string_literal: true

class ChileCategoriesSetupJob
  include Sidekiq::Job
  queue_as :categories
  sidekiq_options retry: false

  def perform
    ZecatSync::CategorySync.new('Chile').iterate_categories_and_sync
  end
end
