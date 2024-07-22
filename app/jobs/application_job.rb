# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  rescue_from(StandardError) do |exception|
    Rails.logger.error "Error ocurred while executing job, error was: #{exception}"
  end
end
