# frozen_string_literal: true

# Helper methods for displaying forecast data
module WeatherHelper
  # round temperatures to remove zeroes and add the degree symbol
  def format_temp(temp)
    "#{temp.round}°F"
  end

  # sanitize precipitation_chance data
  def precipitation_chance(chance)
    return '0%' unless chance

    "#{chance}%"
  end
end
