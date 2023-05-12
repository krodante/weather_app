# frozen_string_literal: true

require 'faraday'

# handles calling the OpenWeatherMap API and handling the response data
class Weather
  def initialize(lat, lon, conn = nil)
    return unless lat && lon

    @conn = conn || Faraday.new(
      url: 'https://api.openweathermap.org',
      params: {
        lat:,
        lon:,
        units: 'imperial',
        appid: Rails.application.credentials.weather_api_key
      }
    )
  end

  def cache_json
    {
      current_forecast: current,
      five_day_forecast: forecast
    }
  end

  def current
    response = @conn.get('/data/2.5/weather')
    json_response = JSON.parse(response.body)

    if [200, '200'].include?(json_response['cod'])
      Weather::Forecast.new(json_response)
    else
      show_errors(json_response)
    end
  end

  def forecast
    response = @conn.get('/data/2.5/forecast')
    json_response = JSON.parse(response.body)

    if [200, '200'].include?(json_response['cod'])
      json_response['list'].map do |forecast|
        Weather::Forecast.new(forecast)
      end
    else
      show_errors(json_response)
    end
  end

  def show_errors(json_response)
    case json_response['cod']
    when 401
      raise Weather::Errors::UnauthorizedError, json_response['message']
    when '400'
      raise Weather::Errors::FormatError, json_response['message']
    when 500
      raise Weather::Errors::SystemError, json_response['message']
    end
  end

  module Errors
    class FormatError < StandardError; end
    class SystemError < StandardError; end
    class UnauthorizedError < StandardError; end
  end
end
