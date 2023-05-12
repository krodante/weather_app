# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Location do
  let(:valid_params) do
    {
      text: '123 Main St., Anytown, USA'
    }
  end

  it 'is valid with valid attributes' do
    location = described_class.new(valid_params)

    expect(location.text).to eq(valid_params[:text])
  end
end
