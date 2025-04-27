# frozen_string_literal: true

module ZecatChileApi
  class Base
    class << self
      ZECAT_ENDPOINT = ENV.fetch('ZECAT_CHILE_ENDPOINT', nil)
      CHILE_BEARER_TOKEN = ENV.fetch('CHILE_BEARER_TOKEN', nil)
      BEARER_TOKEN_AUTHORIZATION = { 'Authorization' => "Bearer #{CHILE_BEARER_TOKEN}" }.freeze
    end
  end
end
