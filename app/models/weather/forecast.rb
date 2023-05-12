# frozen_string_literal: true

class Weather
  # Handles instance attributes for Weather::Forecast objects
  class Forecast
    attr_accessor :description, :feels_like, :humidity, :name, :part_of_day, :precipitation_chance, :rain_volume,
                  :snow_volume, :temp, :temp_max, :temp_min, :time, :title, :wind_gust, :wind_speed, :visibility,
                  :offset_dst_seconds, :offset_std_seconds

    def initialize(forecast, offsets)
      @description = forecast['weather'].first['description']
      @feels_like = forecast['main']['feels_like']
      @humidity = forecast['main']['humidity']
      @name = forecast['name']
      @offset_dst_seconds = offsets[:dst_seconds]
      @offset_std_seconds = offsets[:std_seconds]
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

    # checks if the precipitation type is present in the response
    def try_precip(forecast, precip)
      return unless forecast[precip]

      forecast[precip]['1h'] || forecast[precip]['3h']
    end

    def date
      utc_time = Time.zone.at(time)
      local_time = if utc_time.dst?
                    utc_time + offset_dst_seconds
                  else
                    utc_time + offset_std_seconds
                  end
      local_time.to_date
    end
  end
end
