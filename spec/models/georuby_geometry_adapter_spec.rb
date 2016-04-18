require 'rails_helper'

RSpec.describe GeorubyGeometryAdapter, :type => :model do

  let(:test_adapter) { GeorubyGeometryAdapter.new }

  it 'initializes' do 
    expect(test_adapter.geometry_factory).to be_an_instance_of(GeoRuby::SimpleFeatures::GeometryFactory)
  end

  it '.create_point' do
    test_point = test_adapter.create_point(-68.9847046, 45.2171892)

    expect(test_point.text_geometry_type).to eq("POINT")
    expect(test_point.text_representation).to eq("45.2171892 -68.9847046")
  end
  it '.create_linestring' do
    test_line = test_adapter.create_linestring([[45.217,-68.984], [42.394,-71.144]])

    expect(test_line.text_geometry_type).to eq("LINESTRING")
    expect(test_line.text_representation).to eq("45.217 -68.984,42.394 -71.144")
  end
  it '.create_polygon' do
    test_polygon = test_adapter.create_polygon([[45.217,-68.984], [42.394,-71.144], [44.001,-71.579]])

    expect(test_polygon.text_geometry_type).to eq("POLYGON")
    expect(test_polygon.text_representation).to eq("(45.217 -68.984),(42.394 -71.144),(44.001 -71.579)")
  end

  describe '.create_from_wkt' do
    it 'point' do
      test_point = test_adapter.create_from_wkt("POINT (45.2171892 -68.9847046)")

      expect(test_point.text_geometry_type).to eq("POINT")
      expect(test_point.text_representation).to eq("45.2171892 -68.9847046")
    end
    it 'linestring' do
      test_line = test_adapter.create_from_wkt("LINESTRING (45.217 -68.984, 42.394 -71.144)")

      expect(test_line.text_geometry_type).to eq("LINESTRING")
      expect(test_line.text_representation).to eq("45.217 -68.984,42.394 -71.144")
    end
    it 'polygon' do
      test_polygon = test_adapter.create_from_wkt("POLYGON ((45.217 -68.984),(42.394 -71.144),(44.001 -71.579))")

      expect(test_polygon.text_geometry_type).to eq("POLYGON")
      expect(test_polygon.text_representation).to eq("(45.217 -68.984),(42.394 -71.144),(44.001 -71.579)")
    end
  end
end
