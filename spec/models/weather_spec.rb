require 'rails_helper'

RSpec.describe Weather, type: :model do
  let(:lat) { 37.585232 }
  let(:lon) { -122.473095 }

  describe ".current" do
    it "returns a single Forecast object" do
      weather_api = Weather.new(lat, lon)

      expect(weather_api.current.class).to eq(Weather::Forecast)
    end
  end

  describe ".forecast" do
    it "returns a list of Forecast objects" do
      weather_api = Weather.new(lat, lon)

      forecast = weather_api.forecast

      expect(forecast).to be_an_instance_of(Array)
      expect(forecast.first.class).to eq(Weather::Forecast)
    end
  end
end