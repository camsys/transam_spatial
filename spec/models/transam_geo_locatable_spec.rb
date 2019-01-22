require 'rails_helper'

RSpec.describe TransamGeoLocatable do
  let(:asset_parent_policy) { create(:parent_policy, :fuel_type, subtype: 35) }
  let(:asset_policy) { create(:policy, organization: asset_parent_policy.organization, parent: asset_parent_policy) }
  let(:facility_parent_policy) { create(:parent_policy, subtype: 24) }
  let(:facility_policy) { create(:policy, organization: facility_parent_policy.organization, parent: facility_parent_policy) }
  let(:infrastructure_parent_policy) { create(:parent_policy, subtype: 61) }
  let(:infrastructure_policy) { create(:policy, organization: infrastructure_parent_policy.organization, parent: infrastructure_parent_policy) }
  let(:test_infrastructure) { create(:infrastructure, organization: infrastructure_policy.organization) }
  let(:test_facility) { create(:facility, organization: facility_policy.organization) }
  let(:test_asset) { create(:service_vehicle, organization: asset_policy.organization, location: test_facility.transam_assetible) }
  let(:geometry_adapter) { RgeoGeometryAdapter.new }


  it 'configure_geolocatable' do
    expect(test_asset._geolocatable_geometry_attribute_name).to eq("geometry")
    expect(test_asset._icon_class).to eq("blueIcon")
    expect(test_asset._update_on_save).to be true
    expect(test_asset._use_nodes).to be false
    expect(test_asset._tolerate_update_geometry_error).to be false
  end

  it 'mappable?' do
    expect(test_asset.mappable?).to be false
    test_asset.geometry = geometry_adapter.create_point(50, 50)
    expect(test_asset.mappable?).to be true
  end

  it 'map_markers' do
    expect(test_asset.map_markers).to eq([{}])
    test_asset.geometry = geometry_adapter.create_point(50, 50)
    expect(test_asset.map_markers).to eq([{"id" => test_asset.object_key, "lat" => 50.0, "lng" => 50.0, "zindex" => 0, "name" => test_asset.to_s, "iconClass" => "blueIcon", "draggable" => false, "title" => test_asset.to_s, "description" => nil}])
  end

  it 'map_marker_without_popup' do
    test_asset.geometry = geometry_adapter.create_point(50, 50)
    expect(test_asset.map_marker_without_popup).to eq({"id" => test_asset.object_key, "lat" => 50.0, "lng" => 50.0, "zindex" => 0, "name" => test_asset.to_s, "iconClass" => "blueIcon", "draggable" => false, "title" => test_asset.to_s})
  end

  describe 'longitude_from_geometry' do
    it 'no geometry' do
      test_asset.geometry = nil
      expect(test_asset.longitude_from_geometry).to eq(nil)
    end
    it 'formats x value' do
      test_asset.geometry = geometry_adapter.create_point(50,50)
      expect(test_asset.longitude_from_geometry).to eq("50&deg;".html_safe)
    end
  end

  describe 'latitude_from_geometry' do
    it 'no geometry' do
      test_asset.geometry = nil
      expect(test_asset.latitude_from_geometry).to eq(nil)
    end
    it 'formats y value' do
      test_asset.geometry = geometry_adapter.create_point(50,50)
      expect(test_asset.latitude_from_geometry).to eq("50&deg;".html_safe)
    end
  end

  describe 'dms_longtitude_from_geometry' do
    it 'no geometry' do
      test_asset.geometry = nil
      expect(test_asset.dms_longitude_from_geometry).to eq(nil)
    end
    describe 'converts to dms format' do
      it 'just degrees' do
        test_asset.geometry = geometry_adapter.create_point(50,50)
        expect(test_asset.dms_longitude_from_geometry).to eq("50&deg; 0\' 0\" E".html_safe)
      end
      it 'just degrees and mins' do
        test_asset.geometry = geometry_adapter.create_point(50.25,50.25)
        expect(test_asset.dms_longitude_from_geometry).to eq("50&deg; 15\' 0\" E".html_safe)
      end
      it 'DMS' do
        test_asset.geometry = geometry_adapter.create_point(50.2525,50.2525)
        expect(test_asset.dms_longitude_from_geometry).to eq("50&deg; 15\' 9\" E".html_safe)
      end
    end
    it 'handles direction' do
      test_asset.geometry = geometry_adapter.create_point(-50,-50)
      expect(test_asset.dms_longitude_from_geometry).to eq("50&deg; 0\' 0\" W".html_safe)
    end
  end

  describe 'dms_latitude_from_geometry' do
    it 'no geometry' do
      test_asset.geometry = nil
      expect(test_asset.dms_latitude_from_geometry).to eq(nil)
    end
    describe 'converts to dms format' do
      it 'just degrees' do
        test_asset.geometry = geometry_adapter.create_point(50,50)
        expect(test_asset.dms_latitude_from_geometry).to eq("50&deg; 0\' 0\" N".html_safe)
      end
      it 'just degrees and mins' do
        test_asset.geometry = geometry_adapter.create_point(50.25,50.25)
        expect(test_asset.dms_latitude_from_geometry).to eq("50&deg; 15\' 0\" N".html_safe)
      end
      it 'DMS' do
        test_asset.geometry = geometry_adapter.create_point(50.2525,50.2525)
        expect(test_asset.dms_latitude_from_geometry).to eq("50&deg; 15\' 9\" N".html_safe)
      end
    end
    it 'handles direction' do
      test_asset.geometry = geometry_adapter.create_point(-50,-50)
      expect(test_asset.dms_latitude_from_geometry).to eq("50&deg; 0\' 0\" S".html_safe)
    end
  end


  describe 'update_geometry' do
    it 'no location reference type' do
      test_asset.location_reference_type = nil
      expect{test_asset.update_geometry}.to raise_error(ArgumentError, "location reference type is not set")
    end

    it '"NULL" location reference type' do
      test_asset.location_reference_type = LocationReferenceType.find_by_format('NULL')
      expect(test_asset.update_geometry).to be nil
    end

    it '"DERIVED" location reference type' do
      test_asset.set_location_reference
      test_facility.geometry = geometry_adapter.create_point(50, 50)
      expect(test_asset.update_geometry).to eq(test_facility.geometry)
    end

    it 'parse with errors' do
      test_infrastructure.longitude = "invalid"
      test_infrastructure.latitude = "coordinate"
      test_infrastructure.set_location_reference
      expect{test_infrastructure.update_geometry}.to raise_error(ArgumentError, "location reference service returned errors")
    end

    it 'has point coords' do
      test_infrastructure.longitude = 50.0
      test_infrastructure.latitude = 50.0
      test_infrastructure.set_location_reference
      test_infrastructure.update_geometry
      expect(test_infrastructure.geometry).to eq(geometry_adapter.create_point(50, 50))
    end

    it 'has linestring coords', :skip do # TODO: figure out how to pass in an array of multiple coordinates

    end

    it 'uses nodes', :skip do # TODO: geocoder doesn't seem to support nodes

    end
  end

  describe 'validate_location_reference' do
    it 'has no location reference type' do
      test_facility.location_reference_type = nil
      expect(test_facility.validate_location_reference).to be false
    end

    it 'parse with errors' do
      test_infrastructure.longitude = "invalid"
      test_infrastructure.latitude = "coordinate"
      test_infrastructure.set_location_reference
      expect(test_infrastructure.validate_location_reference).to be false
    end
  end
end