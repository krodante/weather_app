# frozen_string_literal: true

class WeatherController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[index show]

  def index; end

  def show
    @read_from_cache = true
    cached_weather = read_or_write_cache
    if cached_weather
      @weather_current = cached_weather[:current_forecast]
      @weather_forecast = cached_weather[:five_day_forecast].group_by { |forecast| Time.zone.at(forecast.time).to_date }
    else
      redirect_to action: "index"
    end
  end

  private

  def location_params
    params.require(:location).permit(:text)
  end

  def parse_zipcode(text)
    text.match(/\d{1,5}/).to_s
  end

  def read_or_write_cache
    zipcode = parse_zipcode(location_params[:text])

    return unless zipcode.present?

    Rails.cache.fetch(zipcode, expires_in: 1.minute) do
      @read_from_cache = false
      location = Location.new(location_params).set_coordinates
      weather_api = Weather.new(location.lat, location.lon)
      weather_api.cache_json
    end
  end

end
