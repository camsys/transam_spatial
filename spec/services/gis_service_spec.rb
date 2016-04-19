require 'rails_helper'

RSpec.describe GisService, :type => :service do

  class TestPoint
    attr_accessor :lat
    attr_accessor :lon
  end

  let(:test_gis_service) { GisService.new }

  it '.euclidean_distance' do
    pending('TODO')
    fail
  end
  it '.from_wkt' do
    pending('TODO')
    fail
  end

  it '.search_box_from_bbox' do
    expect(test_gis_service.search_box_from_bbox("0,1,50,51").to_s). to eq("POLYGON ((0.0 1.0, 0.0 51.0, 50.0 51.0, 50.0 1.0, 0.0 1.0))")
  end

  it '.search_box_from_point', :skip do # currently calls MILE not Uom::MILE
    test_point = TestPoint.new
    test_point.lat = 5
    test_point.lon = 5

    search_distance_in_radians = 5.0 / GisService::EARTHS_RADIUS_MILES
    delta_lat = test_gis_service.send(:rad2deg,search_distance_in_radians)
    calc_lon = search_distance_in_radians/Math.cos(test_gis_service.send(:deg2rad,test_point.lat))
    delta_lon = test_gis_service.send(:rad2deg, calc_lon)

    # bounding box (in degrees)
    maxLat = 5 + delta_lat
    minLat = 5 - delta_lat
    maxLon = 5 + delta_lon
    minLon = 5 - delta_lon

    expect(test_gis_service.search_box_from_point(test_point, 5).to_s).to eq("POLYGON ((#{minLon} #{minLat}, #{minLon} #{maxLat}, #{maxLon} #{maxLat}, #{maxLon} #{minLat}, #{minLon} #{minLat}))")
  end

  it '#convert_dd_to_uom' do
    expect(GisService.convert_dd_to_uom(5280, Uom::FEET).round(2)).to eq(GisService::DD_TO_MILES.round(2))
    expect(GisService.convert_dd_to_uom(1760, Uom::FEET).round(3)).to eq((GisService::DD_TO_MILES/3).round(3))
    expect(GisService.convert_dd_to_uom(5, Uom::MILE).round(3)).to eq((GisService::DD_TO_MILES*5).round(3))
  end
  it '#convert_uom_to_dd' do
    expect(GisService.convert_uom_to_dd(5280, Uom::FEET).round(3)).to eq((1/GisService::DD_TO_MILES).round(3))
    expect(GisService.convert_uom_to_dd(1760, Uom::FEET).round(3)).to eq((1/(3*GisService::DD_TO_MILES)).round(3))
    expect(GisService.convert_uom_to_dd(5, Uom::MILE).round(3)).to eq((5/GisService::DD_TO_MILES).round(3))
  end

  it '.as_point' do
    expect(test_gis_service.as_point(45.2171892,-68.9847046).to_s).to eq("POINT (45.2171892 -68.9847046)")
  end
  it '.as_linestring' do
    expect(test_gis_service.as_linestring([[45.217,-68.984], [42.394,-71.144]]).to_s).to eq("LINESTRING (45.217 -68.984, 42.394 -71.144)")
  end
  it '.as_polygon' do
    expect(test_gis_service.as_polygon([[45.217,-68.984], [42.394,-71.144], [44.001,-71.579]]).to_s).to eq("POLYGON ((45.217 -68.984, 42.394 -71.144, 44.001 -71.579, 45.217 -68.984))")
  end

  it '.rad2deg' do
    expect(test_gis_service.send(:rad2deg, (Math::PI/4)).round).to eq(45)
    expect(test_gis_service.send(:rad2deg, (Math::PI/3)).round).to eq(60)
    expect(test_gis_service.send(:rad2deg, (Math::PI/2)).round).to eq(90)
    expect(test_gis_service.send(:rad2deg, (Math::PI)).round).to eq(180)
    expect(test_gis_service.send(:rad2deg, (3*Math::PI/2)).round).to eq(270)
    expect(test_gis_service.send(:rad2deg, (2*Math::PI)).round).to eq(360)
  end
  it '.deg2rad' do
    expect(test_gis_service.send(:deg2rad, 45).round(4)).to eq((Math::PI/4).round(4))
    expect(test_gis_service.send(:deg2rad, 60).round(4)).to eq((Math::PI/3).round(4))
    expect(test_gis_service.send(:deg2rad, 90).round(4)).to eq((Math::PI/2).round(4))
    expect(test_gis_service.send(:deg2rad, 180).round(4)).to eq((Math::PI).round(4))
    expect(test_gis_service.send(:deg2rad, 270).round(4)).to eq((3*Math::PI/2).round(4))
    expect(test_gis_service.send(:deg2rad, 360).round(4)).to eq((2*Math::PI).round(4))
  end
end
