require "faraday"

class Weather
  def initialize(lat, lon, conn = nil)
    if lat && lon
      @conn = conn || Faraday.new(
        url: 'https://api.openweathermap.org',
        params: {
          lat: lat,
          lon: lon,
          units: "imperial",
          appid: Rails.application.credentials.weather_api_key
        }
      )
    end
  end

  def cache_json
    {
      current_forecast: current,
      five_day_forecast: forecast
    }    
  end
  

  def current
    response = @conn.get("/data/2.5/weather")
    json_response = JSON.parse(response.body)

    if json_response["cod"] == 200
      Weather::Forecast.new(json_response)
    else
      show_errors(json_response)
    end
  end

  def forecast
    response = @conn.get("/data/2.5/forecast")
    json_response = JSON.parse(response.body)

    if json_response["cod"] == "200"
      json_response["list"].map do |forecast|
        Weather::Forecast.new(forecast)
      end
    else
      show_errors(json_response)
    end
  end

  def show_errors(json_response)
    case json_response["cod"]
    when 401
      raise Weather::Errors::UnauthorizedError.new(json_response["message"])
    when "400"
      raise Weather::Errors::FormatError.new(json_response["message"])
    when 500
      raise Weather::Errors::SystemError.new(json_response["message"])
    end
  end

  module Errors
    class FormatError < StandardError; end
    class SystemError < StandardError; end
    class UnauthorizedError < StandardError; end
  end
end
