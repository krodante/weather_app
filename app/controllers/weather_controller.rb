# frozen_string_literal: true

class WeatherController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[index show]

  def index; end

  def show
    @read_from_cache = true
    encoded_location = Base64.encode64(location_params[:text])
    cached_weather = Rails.cache.fetch(encoded_location, expires_in: 1.minute) do
      @read_from_cache = false
      location = Location.new(location_params).set_coordinates
      weather_api = Weather.new(location.lat, location.lon)
      weather_api.cache_json
    end

    @weather_current = cached_weather[:current_forecast]
    @weather_forecast = cached_weather[:five_day_forecast].group_by { |forecast| Time.zone.at(forecast.time).to_date }
  end

  private

  def location_params
    params.require(:location).permit(:text)
  end
end
