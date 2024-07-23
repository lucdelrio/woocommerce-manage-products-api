# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  mount Sidekiq::Web, at: '/sidekiq'

  # root to: redirect('/admin')
end
