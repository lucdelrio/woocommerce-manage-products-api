# frozen_string_literal: true

RailsAdmin.config do |config|
  config.asset_source = :sprockets
  # config.asset_source = :sprockets

  ### Popular gems integration

  config.authenticate_with do
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["ADMIN_USERNAME"] &&
      password == ENV["ADMIN_PASSWORD"]
    end
  end

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end
end
