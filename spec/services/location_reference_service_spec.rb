require 'rails_helper'

RSpec.describe LocationReferenceService, :type => :service do

  let(:test_service) { LocationReferenceService.new }
  let(:location) { "140 Water St, New York" }

  it 'initialize' do
    expect(test_service.geocoding_service.class.name).to eq('GoogleGeocodingService')
  end

  it '.has_errors?' do
    expect(test_service.has_errors?).to be false
  end

  describe '.parse' do
    it 'non-existent parse method' do
      expect(test_service.parse(location, 'non-existent method')).to be false
      expect(test_service.errors[0]).to eq("Geocoder method parse_non-existent method is not supported for geocoding service GoogleGeocodingService")
    end
    it 'address', :skip do # require Google Preminum geocoding service
      parse_results = test_service.parse(location, 'address')
      expect(parse_results).to be true
      expect(test_service.location_reference).to eq(location)
      expect(test_service.format).to eq('address')
      expect(test_service.coords).to eq([[-74.00673019999999, 40.705673]])
      expect(test_service.formatted_location_reference).to be nil
    end
  end

  it '.reset' do
    test_service.parse(location, 'non-existent method')
    expect(test_service.errors.count).to be > 0
    test_service.send(:reset)
    expect(test_service.formatted_location_reference).to be nil
    expect(test_service.coords).to eq([])
    expect(test_service.errors).to eq([])
    expect(test_service.warnings).to eq([])
  end
end
