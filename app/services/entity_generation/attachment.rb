# frozen_string_literal: true

module EntityGeneration
  class Attachment
    class << self
      def fill_images_list(images_list, variations)
        images = []
        images << find_main_image(images_list)

        image_count = variations.count > 5 ? 1 : 4
        image_count = variations.count == 4 ? 3 : image_count
        variations.each do |variation|
          variation['images'].first(image_count).each do |image|
            content = {
              src: image['image_url']
            }
            images << content if image['main'] == false
          end
        end

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
