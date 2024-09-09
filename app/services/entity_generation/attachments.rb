# frozen_string_literal: true

module EntityGeneration
  class Attachments
    class << self
      def fill_images_list(images_list)
        images = []
        images << find_main_image(images_list)

        images_list.each do |item|
          content = {
            src: item['image_url']
          }
          images << content if image['main'] == false
        end

        return images.first(20) if images.count > 20

        images
      end

      def find_main_image(images_list)
        images_list.each do |image|
          return { src: image['image_url'] } if image['main'] == true
        end
      end
    end
  end
end
