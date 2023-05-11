require "cgi"

class Geocoder
  include HTTParty
  base_uri 'https://api.geoapify.com'
  API_KEY = "970c055b0f3d4812bbe76d047377055b"

  def initialize(address)
    @options = { query: { text: format_address(address), apiKey: API_KEY, format: "json" } }
  end

  def convert_to_lat_lon
    response = self.class.get("/v1/geocode/search", @options)
    response["results"].first
  end
  
  def format_address(address)
    CGI.escape("#{address.street1} #{address.city} #{address.state}")
  end
end