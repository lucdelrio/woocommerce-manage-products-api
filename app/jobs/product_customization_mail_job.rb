class ProductCustomizationMailJob
  include Sidekiq::Job
  queue_as :mailers
  sidekiq_options retry: false

  def perform(product_customization_id)
    Rails.logger.info 'Started Job:  ProductCustomizationMail'

    pc = ProductCustomization.find_by(id: product_customization_id)
    return unless pc.present?

    ProductCustomizationMailer.creation_notification(pc).deliver

    Rails.logger.info 'Ended Job:  ProductCustomizationMail'
  end
end
