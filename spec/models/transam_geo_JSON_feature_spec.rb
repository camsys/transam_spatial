require 'rails_helper'

RSpec.describe TransamGeoJSONFeature do

  let(:test_parent_policy) { create(:parent_policy) }
  let(:test_policy) { create(:policy, organization: test_parent_policy.organization, parent: test_parent_policy) }
  let(:test_asset) { create(:facility, organization: test_policy.organization) }
  let(:geometry_adapter) { RgeoGeometryAdapter.new }

  it 'has default configuration' do
    expect(test_asset._geojson_geometry_attribute_name).to eq('geometry')
    expect(test_asset._geojson_properties).to eq([:object_key])

    test_asset.geometry = geometry_adapter.create_point(-98,40)
    expect(test_asset.to_geoJSON).to eq( {type: 'Feature', geometry: {type: 'Point', coordinates: [-98.0, 40.0]}, properties: {id: test_asset.object_key, feature_class: 'TransamAsset', object_key: test_asset.object_key}} )

    test_asset.geometry = geometry_adapter.create_linestring([[-71.06, 42.36], [-122.42, 37.77]])
    expect(test_asset.to_geoJSON).to eq( {type: 'Feature', geometry: {type: 'LineString', coordinates: [[-71.06, 42.36], [-122.42, 37.77]]}, properties: {id: test_asset.object_key, feature_class: 'TransamAsset', object_key: test_asset.object_key}} )
  end

  it 'changes GeoJSON configuration' do
    TransamAsset.configure_geojson(geometry_attribute_name: 'space_def', geojson_properties: {name: 'test property'})
    expect(test_asset._geojson_geometry_attribute_name).to eq('space_def')
    expect(test_asset._geojson_properties[:name]).to eq('test property')
  end

end