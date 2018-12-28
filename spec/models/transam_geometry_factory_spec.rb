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

    it 'invalid adapter' do
      expect{TransamGeometryFactory.new('invalid')}.to raise_error("Geometry Adapter invalid not found.")
    end
  end

  describe 'respond_to?' do
    it 'create' do
      expect(test_rgeo_factory.respond_to?(:create_point, true)).to be true
      expect(test_rgeo_factory.respond_to?(:create_invalid, true)).to be false
    end

    it 'other method' do
      expect(test_rgeo_factory.respond_to?(:instance_eval, true)).to be true
      expect(test_rgeo_factory.respond_to?(:invalid_method, true)).to be false
    end
  end

  describe 'method_missing' do
    it 'create' do
      expect(test_rgeo_factory.create_point(50,50).to_s).to eq("POINT (50.0 50.0)")
    end
    it 'invalid method' do
      expect{test_rgeo_factory.invalid_method}.to raise_error(NoMethodError)
    end
  end
end
