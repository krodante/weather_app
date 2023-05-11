require 'rails_helper'

RSpec.describe Weather, type: :model do
  let(:json_response) { File.read("#{__dir__}/../support/weather/#{json_response_file}") }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:lat) { 37.585232 }
  let(:lon) { -122.473095 }
  let(:weather_api) { described_class.new(lat, lon, conn) }  

  describe "Error Handling" do

    describe "401 - Unauthorized" do
      let(:json_response_file) { "401.json" }

      it "returns Weather::Errors::UnauthorizedError when unauthorized" do
        stubs.get("/data/2.5/weather") do
          [401, { 'Content-Type': 'application/json' }, json_response]
        end
        
        expect { weather_api.current }.to raise_error(Weather::Errors::UnauthorizedError)
      end
    end

    describe "400 - Invalid params" do
      let(:json_response_file) { "400.json" }

      it "returns Weather::Errors::FormatError when the latitude or longitude is invalid" do
        stubs.get("/data/2.5/weather") do
          [400, { 'Content-Type': 'application/json' }, json_response]
        end
        
        expect { weather_api.current }.to raise_error(Weather::Errors::FormatError, "wrong latitude")
      end
    end

    describe "500 - System Error" do
      let(:json_response_file) { "500.json" }

      it "returns Weather::Errors::SystemError when the API is down" do
        stubs.get("/data/2.5/weather") do
          [500, { 'Content-Type': 'application/json' }, json_response]
        end
        
        expect { weather_api.current }.to raise_error(Weather::Errors::SystemError, "System Error")
      end
    end
  end

  describe ".current" do
    let(:json_response_file) { "current/200.json" }
    it "returns a single Forecast object" do
      stubs.get("/data/2.5/weather") do
        [200, { 'Content-Type': 'application/json' }, json_response]
      end      

      expect(weather_api.current.class).to eq(Weather::Forecast)
    end
  end

  describe ".forecast" do
    let(:json_response_file) { "forecast/200.json" }

    it "returns an array of Forecast objects" do
      stubs.get("/data/2.5/forecast") do
        [200, { 'Content-Type': 'application/json' }, json_response]
      end

      forecast = weather_api.forecast

      expect(forecast).to be_an_instance_of(Array)
      expect(forecast.first.class).to eq(Weather::Forecast)
    end
  end
end