class WeatherController < ApplicationController

  def index
    @location = 
      if params["address"]
         Location.new(location_params).set_coordinates
      else
        nil
      end
  end
  
  def show
    puts "-------------------------"
    @location = Location.new(location_params).set_coordinates

    render :show
  #   weather_api = Weather.new(location.lat, location.lon)

  #   weather_current = weather_api.current
  #   weather_forecast = weather_api.forecast
  end

  private

    def location_params
      permitted = params.require(:address).permit(:street1, :street2, :city, :state, :country, :zipcode)
      permitted
    end
end
