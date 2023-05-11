require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:valid_params) {
    {
      street1: "1034 Park Pacifica Ave",
      city: "Pacifica",
      state: "CA"
    }
  }
  it "is valid with valid attributes" do
    location = Location.new(valid_params)

    expect(location.street1).to eq(valid_params[:street1])
  end

  describe ".set_coordinates" do
    it "sets the latitude and longitude given a Location object" do
      location = Location.new(valid_params)

      expect(location.lat).to eq(nil)
      expect(location.lon).to eq(nil)

      location.set_coordinates

      expect(location.lat).to eq(37.585232)
      expect(location.lon).to eq(-122.473095)
    end
  end
end