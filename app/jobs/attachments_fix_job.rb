# frozen_string_literal: true

class AttachmentsFixJob
  include Sidekiq::Job
  queue_as :attachments_fix
  sidekiq_options retry: 5, unique: :until_executed

  def perform
    product_list = Product.all.pluck(:zecat_id)
    attachments_list = Attachment.where(zecat_product_id: product_list)
    products_without_attachments = Product.where.not(zecat_id: attachments_list.pluck(:zecat_product_id))
    
    return if products_without_attachments.empty?

    products_without_attachments.each do |product|
      AttachmentsSetupJob.perform_in(3.minutes, self.id)
    end
  end
end
