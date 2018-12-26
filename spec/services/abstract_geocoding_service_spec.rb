require 'rails_helper'

RSpec.describe AbstractGeocodingService do
  let(:test_service) { GoogleGeocodingService.new }

  describe 'reverse_lookup' do
    it 'valid coordinates' do
      expect(test_service.reverse_lookup(42.401721, -71.081997)).to be true
    end

    it 'invalid coordinates', :skip do # not causing any errors
      puts test_service.reverse_search(['abc', 'xyz'])
      expect(test_service.reverse_lookup(999999999999999, 99999999999999999)).to be false
      expect(test_service.has_errors?).to be true
    end
  end

  it 'lookup' do
    expect(test_service.lookup("101 Station Landing, Medford, MA 02155")).to be true
  end

  it 'parse_derived' do
    test_service.parse_derived("Location")
    expect(test_service.formatted_location_reference).to eq("Location")
  end

  describe 'parse_coordinate' do
    it 'LATLNG regex' do
      expect(test_service.parse_coordinate("(10.0, 10.0)")).to be true
    end

    it 'PROJ regex' do
      expect(test_service.parse_coordinate("(150.01, 999.99)")).to be true
    end

    it 'incorrect format' do
      expect(test_service.parse_coordinate("abc, 123")).to be false
    end
  end

  it 'parse_address' do
    expect(test_service.parse_address("101 Station Landing, Medford, MA 02155")).to be true
  end
end