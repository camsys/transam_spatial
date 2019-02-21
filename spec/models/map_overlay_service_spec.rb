require 'rails_helper'

RSpec.describe MapOverlayService, :type => :model do

  let(:test_service) { 
    create(:map_overlay_service) 
  }

  describe 'associations' do
    it 'has an org' do
      expect(test_service).to belong_to(:organization)
    end
    it 'has a creator' do
      expect(test_service).to belong_to(:creator)
    end
    it 'has a type' do
      expect(test_service).to belong_to(:map_overlay_service_type)
      expect(test_service.map_overlay_service_type.name).to eq("Test Name")
    end
  end
  describe 'validations' do
    it 'must have a type' do
      test_service.map_overlay_service_type = nil

      expect(test_service.valid?).to be false
    end

    it 'must have a name' do
      test_service.name = nil

      expect(test_service.valid?).to be false
    end

    it 'must have a url' do
      test_service.url = nil

      expect(test_service.valid?).to be false
    end
  end

  it '#allowable_params' do
    expect(MapOverlayService.allowable_params).to eq([
      :name,
      :url,
      :organization_id,
      :map_overlay_service_type_id,
      :active
    ])
  end

  it '.to_s' do
    expect(test_service.to_s).to eq(test_service.name)
  end

end
