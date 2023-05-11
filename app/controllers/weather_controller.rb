class WeatherController < ApplicationController
  def show
    location = Location.new(params).set_coordinates
    weather_api = Weather.new(location.lat, location.lon)

    weather_current = weather_api.current
    weather_forecast = weather_api.forecast
  end
end
