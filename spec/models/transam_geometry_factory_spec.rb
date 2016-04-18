#-------------------------------------------------------------------------------
#
# TransamGeometryFactory model spec
# Only GeoRuby support is covered. RGeo support is included in SIMS application
#
#-------------------------------------------------------------------------------
require 'rails_helper'

RSpec.describe TransamGeometryFactory do
  let(:test_factory) { TransamGeometryFactory.new('georuby') }

  it 'initializes' do
    expect(test_factory.geometry_adapter).to be_an_instance_of(GeorubyGeometryAdapter)
  end
end
