# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  NOTIFICATION_EMAIL = ENV.fetch('NOTIFICATION_EMAIL', nil)
  default from: NOTIFICATION_EMAIL
  layout 'mailer'
end
