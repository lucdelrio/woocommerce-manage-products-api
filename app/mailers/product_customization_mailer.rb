class ProductCustomizationMailer < ApplicationMailer
  NOTIFICATION_EMAIL = ENV.fetch('NOTIFICATION_EMAIL', nil)
  SUPPORT_EMAIL = ENV.fetch('SUPPORT_EMAIL', nil)

  default from: NOTIFICATION_EMAIL

  def creation_notification(product_customization)
    @product_customization = product_customization

    return unless SUPPORT_EMAIL.present?
    
    mail(to: SUPPORT_EMAIL,
         subject: I18n.t('operations_mailer.creation_notification.subject', country: product_customization.country))
  end
end
