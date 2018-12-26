require 'rails_helper'

RSpec.describe TransamGeocodable do

  context 'geocode an organization' do
    let(:test_org) { create(:organization, address1: "123 Fake Street", city: "Bloston", state: "MA", zip: "00000") }

    it 'icon_class' do
      expect(test_org.icon_class).to eq('blueIcon')
    end

    it 'is located in Massachusetts' do
      expect(test_org.latitude).to be_within(0.000001).of(42.360083)
      expect(test_org.longitude).to be_within(0.000001).of(-71.05888)
    end

    it 'is located in Medford' do
      test_org.city = "Medford"
      test_org.geocode
      expect(test_org.latitude).to be_within(0.000001).of(42.418430)
      expect(test_org.longitude).to be_within(0.000001).of(-71.106164)
    end

    it 'is located in the 02155 zip code' do
      test_org.zip = "02155"
      test_org.geocode
      expect(test_org.latitude).to be_within(0.000001).of(42.427497)
      expect(test_org.longitude).to be_within(0.000001).of(-71.109201)
    end

    it 'is located at CS' do
      test_org.address1 = "101 Station Landing"
      test_org.geocode
      expect(test_org.latitude).to be_within(0.000001).of(42.401721)
      expect(test_org.longitude).to be_within(0.000001).of(-71.081997)
    end
  end

  context 'geocode a vendor' do
    let(:test_vendor) { create(:vendor) }

    it 'icon_class' do
      expect(test_vendor.icon_class).to eq('blueIcon')
    end

    it 'has default state (PA)' do
      expect(test_vendor.latitude).to be_within(0.000001).of(41.2033216)
      expect(test_vendor.longitude).to be_within(0.000001).of(-77.1945247)
    end

    it 'is located in Harrisburg' do
      test_vendor.city = "Harrisburg"
      test_vendor.geocode
      expect(test_vendor.latitude).to be_within(0.000001).of(40.2731911)
      expect(test_vendor.longitude).to be_within(0.000001).of(-76.8867008)
    end

    it 'is located in the 17120 zip code' do
      test_vendor.zip = "17120"
      test_vendor.geocode
      expect(test_vendor.latitude).to be_within(0.000001).of(40.2651105)
      expect(test_vendor.longitude).to be_within(0.000001).of(-76.8843467)
    end

    it 'is located at 400 North Street' do
      test_vendor.address1 = "400 North Street"
      test_vendor.geocode
      expect(test_vendor.latitude).to be_within(0.000001).of(40.2664611)
      expect(test_vendor.longitude).to be_within(0.000001).of(-76.8838063)
    end
  end
end