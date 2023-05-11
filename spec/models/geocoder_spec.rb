require 'rails_helper'

RSpec.describe Geocoder, type: :model do
  let(:valid_params) {
    {
      street1: "1034 Park Pacifica Ave",
      city: "Pacifica",
      state: "CA"
    }
  }

  describe ".format_address" do
    it "initializes with formatted address" do
      address = Location.new(valid_params)
      geocoder = Geocoder.new(address)
      formatted = geocoder.format_address(address)

      expect(formatted).to eq("1034+Park+Pacifica+Ave+Pacifica+CA")
    end
  end
end