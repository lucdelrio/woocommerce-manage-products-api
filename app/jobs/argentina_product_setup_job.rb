# frozen_string_literal: true

class ArgentinaProductSetupJob
  include Sidekiq::Job
  queue_as :products_iteration
  sidekiq_options retry: false

  def perform
    Integration::Products.new('Argentina').iterate_products_and_create
  end
end
