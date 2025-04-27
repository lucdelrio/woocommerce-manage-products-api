# frozen_string_literal: true

module ZecatArgentinaApi
  class Base
    class << self
      ZECAT_ENDPOINT = ENV.fetch('ZECAT_ARGENTINA_ENDPOINT', nil)
      ARGENTINA_BEARER_TOKEN = ENV.fetch('ARGENTINA_BEARER_TOKEN', nil)
      BEARER_TOKEN_AUTHORIZATION = { 'Authorization' => "Bearer #{ARGENTINA_BEARER_TOKEN}" }.freeze
    end
  end
end
