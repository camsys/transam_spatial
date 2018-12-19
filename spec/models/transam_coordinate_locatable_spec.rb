require 'rails_helper'

RSpec.describe TransamCoordinateLocatable do

  let(:test_parent_policy) { create(:parent_policy) }
  let(:test_policy) { create(:policy, organization: test_parent_policy.organization, parent: test_parent_policy) }
  let(:test_infrastructure) { create(:infrastructure, organization: test_policy.organization) }

  it 'green dot icon_class' do
    expect(test_infrastructure.icon_class).to eq('greenDotIcon')
  end

  it 'set_location_reference' do
    test_infrastructure.set_location_reference
    expect(test_infrastructure.location_reference_type).to eq(LocationReferenceType.find_by_format('NULL'))
    expect(test_infrastructure.location_reference).to be_nil
  end

end