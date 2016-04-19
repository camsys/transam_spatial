require 'rails_helper'

RSpec.describe RgeoGeometryAdapter, :type => :model do

  let(:test_adapter) { RgeoGeometryAdapter.new }

  it '.create_unprojected_point' do
    expect(test_adapter.create_unprojected_point(45.2171892,-68.9847046).to_s).to eq("POINT (-77.51941294756288 40.11220108433825)")
  end
  it '.create_projected_point' do
    expect(test_adapter.create_projected_point(45.2171892,-68.9847046).to_s).to eq("POINT (119186698.55758864 -689179.1571531742)")
  end
  it '.create_point' do
    expect(test_adapter.create_point(45.2171892,-68.9847046).to_s).to eq("POINT (45.2171892 -68.9847046)")
  end
  it '.create_linestring' do
    test_line = test_adapter.create_linestring([[45.217,-68.984], [42.394,-71.144]])
    expect(test_line.to_s).to eq("LINESTRING (45.217 -68.984, 42.394 -71.144)")
  end
  it '.create_polygon' do
    test_polygon = test_adapter.create_polygon([[45.217,-68.984], [42.394,-71.144], [44.001,-71.579]])

    expect(test_polygon.to_s).to eq("POLYGON ((45.217 -68.984, 42.394 -71.144, 44.001 -71.579, 45.217 -68.984))")
  end

  describe '.create_from_wkt' do
    it 'point' do
      test_point = test_adapter.create_from_wkt("POINT (45.2171892 -68.9847046)")

      expect(test_point.to_s).to eq("POINT (45.2171892 -68.9847046)")
    end
    it 'linestring' do
      test_line = test_adapter.create_from_wkt("LINESTRING (45.217 -68.984, 42.394 -71.144)")

      expect(test_line.to_s).to eq("LINESTRING (45.217 -68.984, 42.394 -71.144)")
    end
    it 'polygon' do
      test_polygon = test_adapter.create_from_wkt("POLYGON ((45.217 -68.984, 42.394 -71.144, 44.001 -71.579, 45.217 -68.984))")

      expect(test_polygon.to_s).to eq("POLYGON ((45.217 -68.984, 42.394 -71.144, 44.001 -71.579, 45.217 -68.984))")
    end
  end
end
