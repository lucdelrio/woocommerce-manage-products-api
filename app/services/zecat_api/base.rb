# frozen_string_literal: true

module ZecatApi
  class Base
    class << self
      ZECAT_ENDPOINT = ENV.fetch('ZECAT_ENDPOINT')
    end
  end
end
