#-------------------------------------------------------------------------------
#
# TransamGeometryFactory model spec
# Only GeoRuby support is covered. RGeo support is included in SIMS application
#
#-------------------------------------------------------------------------------
require 'rails_helper'

RSpec.describe TransamGeometryFactory do
  let(:test_georuby_factory) { TransamGeometryFactory.new('georuby') }
  let(:test_rgeo_factory) { TransamGeometryFactory.new('rgeo') }

  describe 'initializes' do
    it "georuby geometry adapter" do
      expect(test_georuby_factory.geometry_adapter).to be_an_instance_of(GeorubyGeometryAdapter)
    end

    it "rgeo geometry adapter" do
      expect(test_rgeo_factory.geometry_adapter).to be_an_instance_of(RgeoGeometryAdapter)
    end
  end
end
