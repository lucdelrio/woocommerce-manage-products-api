
class CountrySelection
  class << self
    def list
      ['Argentina','Chile']
    end

    def zecat_class_name(zecat_country = 'Argentina')
      class_name = "Zecat#{zecat_country}Api"
      Object.const_get( class_name)
    end

    def woocommerce_class_name(woo_country = 'Argentina')
      class_name = "Woocommerce#{woo_country}Api"
      Object.const_get( class_name)
    end
  end
end
