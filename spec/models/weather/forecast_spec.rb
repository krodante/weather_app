# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Weather::Forecast do
  let(:offsets) do
    {
      dst_seconds: -25200,
      std_seconds: -28800
    }
  end

  let(:valid_params) do
    {
      'coord' => {
        'lon' => -122.4731,
        'lat' => 37.5852
      },
      'weather' => [{
        'id' => 803,
        'main' => 'Clouds',
        'description' => 'broken clouds',
        'icon' => '04n'
      }],
      'base' => 'stations',
      'main' => {
        'temp' => 52.99,
        'feels_like' => 51.69,
        'temp_min' => 50.14,
        'temp_max' => 56.08,
        'pressure' => 1018,
        'humidity' => 79
      },
      'visibility' => 10_000,
      'wind' => {
        'speed' => 11.99,
        'deg' => 300,
        'gust' => 15.99
      },
      'clouds' => {
        'all' => 75
      },
      'dt' => 1_683_776_601,
      'sys' => {
        'type' => 2,
        'id' => 2_035_599,
        'country' => 'US',
        'sunrise' => 1_683_723_909,
        'sunset' => 1_683_774_450
      },
      'timezone' => -25_200,
      'id' => 5_380_420,
      'name' => 'Pacifica',
      'cod' => 200
    }
  end

  it 'is valid with valid attributes' do
    forecast = described_class.new(valid_params, offsets)

    expect(forecast.description).to eq(valid_params['weather'].first['description'])
    expect(forecast.feels_like).to eq(valid_params['main']['feels_like'])
    expect(forecast.humidity).to eq(valid_params['main']['humidity'])
    expect(forecast.part_of_day).to eq(valid_params['sys']['pod'])
    expect(forecast.precipitation_chance).to eq(valid_params['pop'])
    expect(forecast.rain_volume).to be_nil
    expect(forecast.snow_volume).to be_nil
    expect(forecast.temp).to eq(valid_params['main']['temp'])
    expect(forecast.temp_max).to eq(valid_params['main']['temp_max'])
    expect(forecast.temp_min).to eq(valid_params['main']['temp_min'])
    expect(forecast.time).to eq(valid_params['dt'])
    expect(forecast.title).to eq(valid_params['weather'].first['main'])
    expect(forecast.wind_gust).to eq(valid_params['wind']['gust'])
    expect(forecast.wind_speed).to eq(valid_params['wind']['speed'])
    expect(forecast.visibility).to eq(valid_params['visibility'])
  end

  describe '.date' do
    it 'returns the current date with utc offset' do
      time_new = Time.new(2023, 05, 10, 23, 00)
      time_utc = time_new.getutc

      expect(time_utc.to_date.to_s).to eq('2023-05-11')

      local_time = time_utc.localtime
      forecast = described_class.new(valid_params, offsets)

      location_date = forecast.date
      expect(location_date.to_s).to eq('2023-05-10')
    end
  end
end
