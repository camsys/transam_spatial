require 'rails_helper'

RSpec.describe TransamParentLocatable do
  let(:asset_parent_policy) { create(:parent_policy, :fuel_type, subtype: 35) }
  let(:asset_policy) { create(:policy, organization: asset_parent_policy.organization, parent: asset_parent_policy) }
  let(:facility_parent_policy) { create(:parent_policy, subtype: 24) }
  let(:facility_policy) { create(:policy, organization: facility_parent_policy.organization, parent: facility_parent_policy) }
  let(:test_facility) { create(:facility, organization: facility_policy.organization) }
  let(:test_asset) { create(:service_vehicle, organization: asset_policy.organization, location: test_facility.transam_assetible) }

  it 'icon_class' do
    expect(test_asset.icon_class).to eq('purpleIcon')
  end

  it 'derive_geometry' do
    test_asset.derive_geometry
    expect(test_asset.geometry).to eq(test_facility.geometry)
  end

  describe 'set_location_reference' do
    it 'with location' do
      test_asset.set_location_reference
      expect(test_asset.location_reference).to eq("Derived from location")
    end

    it 'without location' do
      test_asset.location = nil
      test_asset.set_location_reference
      expect(test_asset.location_reference).to be nil
    end
  end
end