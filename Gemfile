# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

gem 'active_interaction', '~> 5.3.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.18.3', require: false

gem 'health_check', '~> 3.1.0'
gem 'httparty', '~> 0.22.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.1'
gem 'rails_admin', '~> 3.1.4'

# CronJobs
gem 'sidekiq', '~> 7.3.0'
gem 'sidekiq-cron', '~> 1.12'
gem 'sidekiq-failures', '~> 1.0.4'

# Use pg as the database for Active Record
gem 'pg', '~> 1.5.6'

# Use Puma as the app server
gem 'puma', '~> 3.12'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

gem 'sassc-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rubocop', '~> 1.60.0', require: false
  # gem 'vcr', '~> 4.0'
  # gem 'webmock', '~> 3.5.1'
  gem 'dotenv-rails', '~> 2.7.1'
  gem 'rspec-rails', '~> 3.8.2'
end

group :development do
  gem 'listen', '~> 3.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 4.0.0'
  gem 'spring-watcher-listen', '~> 2.1.0'
end

group :test do
  gem 'simplecov', '~> 0.12.0'
end
