require "faraday"

class Weather
  API_KEY="4dfc7fb711c57801d00402d7d0445eaf"

  def initialize(lat = nil, lon = nil)
    if lat && lon
      @conn = Faraday.new(
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
    Weather::Forecast.new(JSON.parse(response.body))
  end

  def forecast
    response = @conn.get("/data/2.5/forecast")

    JSON.parse(response.body)["list"].map do |forecast|
      Weather::Forecast.new(forecast)
    end
  end
end
