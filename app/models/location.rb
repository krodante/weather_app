# frozen_string_literal: true

# Handles location data
class Location
  attr_accessor :text, :lat, :lon

  def initialize(params = {})
    @text = params[:text]
  end

  # Calls the Geocoder API and sets the lat and lon
  def set_location_data
    geocoder = Geocoder.new(self)
    location_data = geocoder.find_from_address
    @lat = location_data['lat']
    @lon = location_data['lon']
    self
  end

  def parse_zipcode
    text.match(/\d{1,5}/).to_s
  end
end
