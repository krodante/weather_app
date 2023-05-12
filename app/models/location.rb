# frozen_string_literal: true

# Handles location data
class Location
  attr_accessor :lat, :lon, :offset_dst_seconds, :offset_std_seconds, :text

  def initialize(params = {})
    @text = params[:text]
  end

  # Calls the Geocoder API and sets attributes
  def set_location_data
    geocoder = Geocoder.new(self)
    location_data = geocoder.find_from_address
    @lat = location_data['lat']
    @lon = location_data['lon']
    @offset_dst_seconds = location_data['timezone']['offset_DST_seconds']
    @offset_std_seconds = location_data['timezone']['offset_STD_seconds']
    self
  end

  def parse_zipcode
    text.match(/\d{1,5}/).to_s
  end

  def date(time)
    utc_time = Time.at(time)
    local_time = if utc_time.dst?
      utc_time + offset_dst_seconds
    else
      utc_time + offset_std_seconds
    end
    local_time.to_date
  end
end
