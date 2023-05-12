# frozen_string_literal: true

class Weather
  class Forecast
    attr_accessor :description, :feels_like, :humidity, :name, :part_of_day, :precipitation_chance, :query, :rain_volume,
                  :snow_volume, :temp, :temp_max, :temp_min, :time, :title, :wind_gust, :wind_speed, :visibility

    def initialize(forecast)
      @description = forecast['weather'].first['description']
      @feels_like = forecast['main']['feels_like']
      @humidity = forecast['main']['humidity']
      @name = forecast['name']
      @part_of_day = forecast['sys']['pod']
      @precipitation_chance = forecast['pop']
      @rain_volume = try_precip(forecast, 'rain')
      @snow_volume = try_precip(forecast, 'snow')
      @temp = forecast['main']['temp']
      @temp_max = forecast['main']['temp_max']
      @temp_min = forecast['main']['temp_min']
      @time = forecast['dt']
      @title = forecast['weather'].first['main']
      @wind_gust = forecast['wind']['gust']
      @wind_speed = forecast['wind']['speed']
      @visibility = forecast['visibility']
    end

    def try_precip(forecast, precip)
      return unless forecast[precip]

      forecast[precip]['1h'] || forecast[precip]['3h']
    end
  end
end
