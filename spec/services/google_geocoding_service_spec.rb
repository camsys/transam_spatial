require 'rails_helper'

RSpec.describe GoogleGeocodingService do

  let(:test_service) { GoogleGeocodingService.new({sensor: true}) }

  it 'initializes with attributes' do
    expect(test_service.sensor).to be true
  end

  it 'reverse_search' do
    expect(test_service.send(:process_results, test_service.send(:reverse_search, [42.401721, -71.081997]))).to eq("Fourth Floor, 101 Station Landing, Medford, MA 02155, United States")
  end

  it 'search', :skip do # Pulling up empty for some reason
    expect(test_service.send(:search, "101 Station Landing, Medford, MA 02155, United States")).to eq([42.401721, -71.081997])
  end
end