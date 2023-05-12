module WeatherHelper

  def format_temp(temp)
    "#{temp.round}°F"
  end

  def precipitation_chance(chance)
    return "0%" unless chance

    "#{chance}%"
  end
end
