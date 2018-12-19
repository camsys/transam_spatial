require 'rails_helper'

RSpec.describe TransamGeoJSONFeature do

  let(:test_parent_policy) { create(:parent_policy) }
  let(:test_policy) { create(:policy, organization: test_parent_policy.organization, parent: test_parent_policy) }
  let(:test_asset) { create(:facility, organization: test_policy.organization) }

  it 'has default configuration' do
    expect(test_asset._geojson_geometry_attribute_name).to eq('geometry')
    expect(test_asset._geojson_properties).to eq([:object_key])
    # TODO: figure out how the use to_geoJSON with test_asset
    # puts test_asset.send(:_geojson_geometry_attribute_name)
    # puts Rails.application.config.transam_spatial_geometry_adapter
    # puts test_asset.geometry.dimension.to_s
    # puts test_asset.send(:_geojson_geometry_attribute_name).points

    # expect(test_asset.to_geoJSON).to eq( {type: 'Feature', geometry: {type: 'Point', coordinates: [0, 0]}, properties: {id: :object_key, feature_class: 'TransitAsset'}} )
  end

  it 'changes GeoJSON configuration' do
    TransamAsset.configure_geojson(geometry_attribute_name: 'space_def', geojson_properties: {name: 'test property'})
    expect(test_asset._geojson_geometry_attribute_name).to eq('space_def')
    expect(test_asset._geojson_properties[:name]).to eq('test property')
  end

end