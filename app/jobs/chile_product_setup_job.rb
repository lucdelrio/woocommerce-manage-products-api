# frozen_string_literal: true

class ChileProductSetupJob
  include Sidekiq::Job
  queue_as :products_iteration
  sidekiq_options retry: false

  def perform
    ZecatSync::ProductIterationForSync.new('Chile').iterate_products_and_create
  end
end
