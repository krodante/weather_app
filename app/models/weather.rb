class Weather
  include HTTParty
  base_uri 'https://api.openweathermap.org'
  API_KEY="4dfc7fb711c57801d00402d7d0445eaf"

  def initialize(lat, lon)
    @options = {
      query: {
        lat: lat,
        lon: lon,
        units: "imperial",
        appid: API_KEY
      }
    }
  end

  def current
    response = self.class.get("/data/2.5/weather", @options)
    Weather::Forecast.new(response)
  end

  def forecast
    response = self.class.get("/data/2.5/forecast", @options)

    response["list"].map do |forecast|
      Weather::Forecast.new(forecast)
    end
  end
end
