require "faraday"

class Geocoder
  def initialize(location, conn = nil)
    @location = location
    @conn = conn || Faraday.new(
      url: 'https://api.geoapify.com',
      params: { apiKey: Rails.application.credentials.geocoder_api_key }
    )
  end

  def convert_to_lat_lon
    response = @conn.get('/v1/geocode/search', { text: @location.text, format: 'json' })

    json_response = JSON.parse(response.body)

    if json_response["results"].present?
      json_response["results"].first
    elsif json_response["statusCode"]
      show_errors(json_response)
    else
      raise Geocoder::Errors::SystemError.new("No results for query: #{json_response["query"]["text"]}")
    end
  end

  def show_errors(json_response)
    case json_response["statusCode"]
    when 401
      raise Geocoder::Errors::UnauthorizedError.new(json_response["message"])
    when "401"
      raise Geocoder::Errors::UnauthorizedError.new(json_response["message"])
    when 400
      raise Geocoder::Errors::FormatError.new(json_response["message"])
    when "400"
      raise Geocoder::Errors::FormatError.new(json_response["message"])
    when 500
      raise Geocoder::Errors::SystemError.new(json_response["message"])
    when "500"
      raise Geocoder::Errors::SystemError.new(json_response["message"])
    end
  end

  module Errors
    class FormatError < StandardError; end
    class SystemError < StandardError; end
    class UnauthorizedError < StandardError; end
  end
end
