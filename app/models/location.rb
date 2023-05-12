# frozen_string_literal: true

class Location
  attr_accessor :text, :lat, :lon

  def initialize(params = {})
    @text = params[:text]
  end

  def set_coordinates
    geocoder = Geocoder.new(self)
    coordinates = geocoder.convert_to_lat_lon
    @lat = coordinates['lat']
    @lon = coordinates['lon']
    self
  end
end
