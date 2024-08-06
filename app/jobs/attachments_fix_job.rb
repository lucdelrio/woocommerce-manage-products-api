# frozen_string_literal: true

class AttachmentsFixJob
  include Sidekiq::Job
  queue_as :attachments_fix
  sidekiq_options retry: 5, unique: :until_executed

  def perform
    CountrySelection::list.each do |country|
      product_list = Product.all.where(country: country).pluck(:zecat_id)
      attachments_list = Attachment.where(zecat_product_id: product_list, country: country)
      products_without_attachments = Product.where.not(zecat_id: attachments_list.pluck(:zecat_product_id)).where(country: country)
      
      return if products_without_attachments.empty?
  
      products_without_attachments.each do |product|
        AttachmentsSetupJob.perform_in(3.minutes, product.id)
      end
    end
  end
end
