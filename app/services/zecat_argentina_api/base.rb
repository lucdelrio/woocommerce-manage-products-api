# frozen_string_literal: true

module ZecatArgentinaApi
  class Base
    class << self
      ZECAT_ENDPOINT = ENV.fetch('ZECAT_ARGENTINA_ENDPOINT', nil)
    end
  end
end
