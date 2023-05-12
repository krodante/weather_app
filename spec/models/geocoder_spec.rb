# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Geocoder do
  let(:json_response) { File.read("#{__dir__}/../support/geocoder/#{json_response_file}") }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:location) { Location.new(text: 'New Address') }
  let(:geocoder) { described_class.new(location, conn) }

  after do
    Faraday.default_connection = nil
  end

  describe '.find_from_address' do
    let(:json_response_file) { '200.json' }

    it 'calls the Geocoder API and returns location data' do
      stubs.get('/v1/geocode/search') do
        [200, { 'Content-Type': 'application/json' }, json_response]
      end

      response = geocoder.find_from_address

      expect(response['lat']).to eq(JSON.parse(json_response)['results'].first['lat'])
      stubs.verify_stubbed_calls
    end
  end

  describe 'Error Handling' do
    describe '401 - Unauthorized' do
      let(:json_response_file) { '401.json' }

      it 'returns Geocoder::Errors::UnauthorizedError when unauthorized' do
        stubs.get('/v1/geocode/search') do
          [401, { 'Content-Type': 'application/json' }, json_response]
        end

        expect { geocoder.find_from_address }.to raise_error(Geocoder::Errors::UnauthorizedError, 'Invalid apiKey')
      end
    end

    describe '400 - FormatError' do
      let(:json_response_file) { '400.json' }

      it 'returns Geocoder::Errors::FormatError when an invalid format is requested' do
        stubs.get('/v1/geocode/search') do
          [400, { 'Content-Type': 'application/json' }, json_response]
        end

        expect do
          geocoder.find_from_address
        end.to raise_error(Geocoder::Errors::FormatError,
                           '"format" must be one of [json, geojson, xml]')
      end
    end

    describe '500 - SystemError' do
      let(:json_response_file) { '500.json' }

      it 'returns Geocoder::Errors::SystemError when an invalid format is requested' do
        stubs.get('/v1/geocode/search') do
          [500, { 'Content-Type': 'application/json' }, json_response]
        end

        expect { geocoder.find_from_address }.to raise_error(Geocoder::Errors::SystemError, 'System Error')
      end
    end

    describe '500 - Empty Results' do
      let(:json_response_file) { '200_empty.json' }

      it 'returns Geocoder::Errors::SystemError when an invalid format is requested' do
        stubs.get('/v1/geocode/search') do
          [200, { 'Content-Type': 'application/json' }, json_response]
        end

        expect do
          geocoder.find_from_address
        end.to raise_error(Geocoder::Errors::SystemError,
                           "No results for query: #{JSON.parse(json_response)['query']['text']}")
      end
    end
  end
end
