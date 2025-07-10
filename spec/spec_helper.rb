require 'rspec'
require 'vcr'
require 'webmock/rspec'

# Automatically require all files in the app directory for specs
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

abort('The Rails environment is running in production mode!') if Rails.env.production?


VCR.configure do |config|
  config.cassette_library_dir = File.expand_path('fixtures/vcr_cassettes', __dir__)
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = true

  config.before_record do |c|
    c.response.body.force_encoding('UTF-8')
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  
  config.example_status_persistence_file_path = ".rspec_status"
  config.order = :random

  # Allow using :vcr metadata
  config.treat_symbols_as_metadata_keys_with_true_values = true if config.respond_to?(:treat_symbols_as_metadata_keys_with_true_values)

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# Shoulda::Matchers.configure do |config|
#   config.integrate do |with|
#     with.test_framework :rspec
#     with.library :rails
#   end
# end
