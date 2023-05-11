class Location
  attr_accessor :street1, :street2, :city, :state, :country, :zipcode, :lat, :lon

  def initialize(params)
    @street1 ||= params[:street1]
    @street2 ||= params[:street2]
    @city ||= params[:city]
    @state ||= params[:state]
    @country ||= params[:country]
    @zipcode ||= params[:zipcode]
  end

  def set_coordinates
    geocoder = Geocoder.new(self)
    coordinates = geocoder.convert_to_lat_lon
    @lat = coordinates["lat"]
    @lon = coordinates["lon"]
    self
  end
  
end