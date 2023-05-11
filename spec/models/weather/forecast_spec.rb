require 'rails_helper'

RSpec.describe Weather::Forecast, type: :model do
  let(:valid_params) {
    {
      "coord" => {
        "lon"=>-122.4731,
        "lat"=>37.5852
      },
      "weather"=> [ {
        "id"=>803,
        "main"=>"Clouds",
        "description"=>"broken clouds",
        "icon"=>"04n"
      } ],
      "base"=>"stations",                      
      "main" => {
        "temp"=>52.99,
        "feels_like"=>51.69,
        "temp_min"=>50.14,
        "temp_max"=>56.08,
        "pressure"=>1018,
        "humidity"=>79
      },
      "visibility"=>10000,                     
      "wind" => {
        "speed"=>11.99,
        "deg"=>300,
        "gust"=>15.99
      },
      "clouds" => {
        "all"=>75
      },                   
      "dt"=>1683776601,                        
      "sys" => {
        "type"=>2,
        "id"=>2035599,
        "country"=>"US",
        "sunrise"=>1683723909,
        "sunset"=>1683774450
      },
      "timezone"=>-25200,                      
      "id"=>5380420,                           
      "name"=>"Pacifica",
      "cod"=>200
    }
  }
  it "is valid with valid attributes" do
    forecast = described_class.new(valid_params)

    expect(forecast.description).to eq(valid_params["weather"].first["description"])
    expect(forecast.feels_like).to eq(valid_params["main"]["feels_like"])
    expect(forecast.humidity).to eq(valid_params["main"]["humidity"])
    expect(forecast.part_of_day).to eq(valid_params["sys"]["pod"])
    expect(forecast.precipitation_chance).to eq(valid_params["pop"])
    expect(forecast.rain_volume).to eq(nil)
    expect(forecast.snow_volume).to eq(nil)
    expect(forecast.temp).to eq(valid_params["main"]["temp"])
    expect(forecast.temp_max).to eq(valid_params["main"]["temp_max"])
    expect(forecast.temp_min).to eq(valid_params["main"]["temp_min"])
    expect(forecast.time).to eq(valid_params["dt"])
    expect(forecast.title).to eq(valid_params["weather"].first["main"])
    expect(forecast.wind_gust).to eq(valid_params["wind"]["gust"])
    expect(forecast.wind_speed).to eq(valid_params["wind"]["speed"])
    expect(forecast.visibility).to eq(valid_params["visibility"])
  end
end