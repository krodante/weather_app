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

  describe '.date' do
    it 'returns the current date with utc offset' do
      time_new = Time.zone.local(2023, 0o5, 10, 23, 0o0)
      time_utc = time_new.getutc

      expect(time_utc.to_date.to_s).to eq('2023-05-11')

      local_time = time_utc.localtime
      params = {
        offset_dst_seconds: local_time.utc_offset,
        offset_std_seconds: local_time.utc_offset
      }
      location = described_class.new(params)

      location_date = location.date(time_utc.to_i)
      expect(location_date.to_s).to eq('2023-05-10')
    end
  end
end
