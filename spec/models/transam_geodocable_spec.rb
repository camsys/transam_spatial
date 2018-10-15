require 'rails_helper'

RSpec.describe TransamGeocodable do

  let(:test_org) { create(:organization, address1: "123 Fake Street", city: "Bloston", state: "MA", zip: "00000") }

  it 'is located in Massachusetts' do
    expect(test_org.latitude).to be_within(0.000001).of(42.407211)
    expect(test_org.longitude).to be_within(0.000001).of(-71.382437)
  end

  it 'is located in Medford' do
    test_org.city = "Medford"
    test_org.geocode
    expect(test_org.latitude).to be_within(0.000001).of(42.418430)
    expect(test_org.longitude).to be_within(0.000001).of(-71.106164)
  end

  it 'is located in the 02155 area code' do
    test_org.zip = "02155"
    test_org.geocode
    expect(test_org.latitude).to be_within(0.000001).of(42.427497)
    expect(test_org.longitude).to be_within(0.000001).of(-71.109201)
  end

  it 'is located at CS' do
    test_org.address1 = "101 Station Landing"
    test_org.geocode
    expect(test_org.latitude).to eq(42.401721)
    expect(test_org.longitude).to eq(-71.081997)
  end
end