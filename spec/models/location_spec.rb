require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:valid_params) {
    {
      text: "123 Main St., Anytown, USA"
    }
  }
  it "is valid with valid attributes" do
    location = Location.new(valid_params)

    expect(location.text).to eq(valid_params[:text])
  end
end