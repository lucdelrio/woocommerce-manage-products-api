# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root to: redirect('/admin')
end
