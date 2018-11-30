require 'rails_helper'

RSpec.describe TransamAddressLocatable do

  let(:test_facility) { create(:facility) }

  it 'green dot icon_class' do
    expect(test_facility.icon_class).to eq('greenDotIcon')
  end

  it 'correct full_address' do
    expect(test_facility.full_address).to eq("101 Station Landing, Suite 410, Medford, MA, 02155")
  end
  
  it 'set_location_reference' do
    expect(test_asset.location_reference_type.name).to eq("Street Address")
    expect(test_asset.location_reference).to eq("101 Station Landing, Suite 410, Medford, MA, 02155")
  end

end