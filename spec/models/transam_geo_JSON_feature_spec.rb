require 'rails_helper'

RSpec.describe TransamGeoJSONFeature do

  it 'has default configuration' do
    asset_type = create(:asset_type)
    asset_subtype = create(:asset_subtype, :asset_type => asset_type)
    parent_organization = create(:organization)
    organization = create(:organization)

    parent_policy = create(:policy, :organization => parent_organization, :parent => nil)
    policy_asset_type_rule = create(:policy_asset_type_rule, :asset_type => asset_type, :policy => parent_policy)
    policy_asset_subtype_rule = create(:policy_asset_subtype_rule, :asset_subtype => asset_subtype, :policy => parent_policy)

    policy = create(:policy, :organization => organization, :parent => parent_policy)
    policy.policy_asset_subtype_rules << policy_asset_subtype_rule
    policy.policy_asset_type_rules << policy_asset_type_rule

    fta_type = create(:fta_bus_type)

    test_asset = build(:buslike_transit_asset, :organization => organization, :asset_subtype => asset_subtype, :fta_type => fta_type)

    expect(TransamAsset._geojson_geometry_attribute_name).to eq('geometry')
    expect(TransamAsset._geojson_properties).to eq([:object_key])
    #test_asset.asset_type.class_name.constantize = Vehicle, but doesn't respond_to?(:_geolocatable_geometry_attribute_name) How to geoJSON???
    expect(test_asset.to_geoJSON).to eq( {type: 'Feature', geometry: {type: 'Point', coordinates: [0, 0]}, properties: {id: :object_key, feature_class: 'TransitAsset'}} )
  end

  it 'changes GeoJSON configuration' do
    TransamAsset.configure_geojson(geometry_attribute_name: 'space_def', geojson_properties: {name: 'test property'})
    expect(TransamAsset._geojson_geometry_attribute_name).to eq('space_def')
    expect(TransamAsset._geojson_properties[:name]).to eq('test property')
  end

end