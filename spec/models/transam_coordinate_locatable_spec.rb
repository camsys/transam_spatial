require 'rails_helper'

RSpec.describe TransamCoordinateLocatable do

  let(:test_parent_policy) { create(:parent_policy) }
  let(:test_policy) { create(:policy, organization: test_parent_policy.organization, parent: test_parent_policy) }
  let(:test_infrastructure) { create(:infrastructure, organization: test_policy.organization) }
  let(:geometry_adapter) { RgeoGeometryAdapter.new }

  it 'green dot icon_class' do
    expect(test_infrastructure.icon_class).to eq('greenDotIcon')
  end

  it 'set_location_reference' do
    expect(test_infrastructure.location_reference_type).to eq(LocationReferenceType.find_by_format('NULL'))
    expect(test_infrastructure.location_reference).to be_nil

    test_infrastructure.geometry = geometry_adapter.create_point(test_infrastructure.organization.longitude, test_infrastructure.organization.latitude)
    test_infrastructure.set_location_reference
    expect(test_infrastructure.location_reference_type).to eq(LocationReferenceType.find_by_format('COORDINATE'))
    expect(test_infrastructure.location_reference).to eq("(#{test_infrastructure.geometry.x},#{test_infrastructure.geometry.y})")

    test_infrastructure.longitude = -98
    test_infrastructure.latitude = 40
    test_infrastructure.set_location_reference
    expect(test_infrastructure.location_reference_type).to eq(LocationReferenceType.find_by_format('COORDINATE'))
    expect(test_infrastructure.location_reference).to eq("(-98,40)")
  end

end