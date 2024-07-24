# frozen_string_literal: true

module ZecatChileApi
  class Base
    class << self
      ZECAT_ENDPOINT = ENV.fetch('ZECAT_CHILE_ENDPOINT', nil)
    end
  end
end
