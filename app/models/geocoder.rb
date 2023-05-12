# frozen_string_literal: true

require 'faraday'

class Geocoder
  def initialize(location, conn = nil)
    @conn = conn || Faraday.new(
      url: 'https://api.geoapify.com',
      params: { apiKey: Rails.application.credentials.geocoder_api_key, text: location.text, format: 'json' }
    )
  end

  def find_from_address
    response = @conn.get('/v1/geocode/search')

    json_response = JSON.parse(response.body)

    if json_response['results'].present?
      json_response['results'].first
    elsif json_response['statusCode']
      show_errors(json_response)
    else
      raise Geocoder::Errors::SystemError, "No results for query: #{json_response['query']['text']}"
    end
  end

  def show_errors(json_response)
    case json_response['statusCode']
    when 401
      raise Geocoder::Errors::UnauthorizedError, json_response['message']
    when 400
      raise Geocoder::Errors::FormatError, json_response['message']
    when 500
      raise Geocoder::Errors::SystemError, json_response['message']
    end
  end

  module Errors
    class FormatError < StandardError; end
    class SystemError < StandardError; end
    class UnauthorizedError < StandardError; end
  end
end
