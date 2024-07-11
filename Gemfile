# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.8'

gem 'active_interaction', '~> 5.3.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.7'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.6.7'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# gem 'faraday', '~> 2.8.1'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

gem 'httparty', '~> 0.22.0'

gem 'sidekiq-cron'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-json_expectations', '~> 2.2.0'
  gem 'rspec-rails', '~> 3.8.2'
  gem 'rubocop', '~> 0.66.0'
  gem 'vcr', '~> 4.0'
  gem 'webmock', '~> 3.5.1'
  gem 'dotenv-rails', '~> 2.7.1'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 4.0.0'
  gem 'spring-watcher-listen', '~> 2.1.0'
end

group :test do
  gem 'simplecov', '~> 0.12.0'
end
