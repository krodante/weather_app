require "faraday"

class Geocoder
  API_KEY="970c055b0f3d4812bbe76d047377055b"

  def initialize(location)
    @conn = Faraday.new(
      url: 'https://api.geoapify.com',
      params: { 
        text: location.text,
        apiKey: API_KEY,
        format: "json"
      }
    )
  end

  def convert_to_lat_lon
    response = @conn.get('/v1/geocode/search')

    JSON.parse(response.body)["results"].first
  end
end