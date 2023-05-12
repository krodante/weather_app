# frozen_string_literal: true

# WeatherController handles calls to the index and show actions
class WeatherController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[index show]

  # Show the address form to fetch the forecast
  def index; end

  def show
    # initialize the the cache indicator
    @read_from_cache = true

    cached_weather = read_or_write_cache

    if cached_weather
      @weather_current = cached_weather[:current_forecast]
      @weather_forecast = cached_weather[:five_day_forecast].group_by do |forecast|
        forecast.date
      end
    # fails when the request does not include a zipcode
    else
      flash[:error] = t('zipcode_error')
      redirect_to action: 'index'
    end

  # rescue errors from the Geocoder or Weather APIs
  rescue StandardError => e
    flash[:error] = e
    redirect_to action: 'index'
  end

  private

  def location_params
    params.require(:location).permit(:text)
  end

  def read_or_write_cache
    @location = Location.new(location_params)
    # parse the zipcode from the location_params
    zipcode = @location.parse_zipcode

    return if zipcode.blank?

    Rails.cache.fetch(zipcode, expires_in: 30.minutes) do
      # this block the return of this block
      # writes to the cache when the key is not found

      # indicates that we are not using cached data
      @read_from_cache = false
      # call the Geocoder and set the Location's lat and lon
      @location.set_location_data

      # send offsets to forecast object to show local forecast
      offsets = {
        dst_seconds: @location.offset_dst_seconds,
        std_seconds: @location.offset_std_seconds
      }
      # instantiate the Weather api with lat and lon
      weather_api = Weather.new(@location.lat, @location.lon)
      # use the Weather api to fetch current and forecast weather
      # and combine that into a single JSON block for the cache
      weather_api.cache_json(offsets)
    end
  end
end
