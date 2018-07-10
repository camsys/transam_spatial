class AddSpatialSystemConfigExtensions < ActiveRecord::DataMigration
  def up
    system_config_extensions = [
        {class_name: 'Organization', extension_name: 'TransamGeocodable', active: true},
        {class_name: 'Vendor', extension_name: 'TransamGeocodable', active: true},
        {class_name: 'Facility', extension_name: 'TransamAddressLocatable', active: true},
        {class_name: 'RevenueVehicle', extension_name: 'TransamParentLocatable', active: true},
        {class_name: 'ServiceVehicle', extension_name: 'TransamParentLocatable', active: true},
        {class_name: 'CapitalEquipment', extension_name: 'TransamParentLocatable', active: true},
        {class_name: 'FacilityComponent', extension_name: 'TransamParentLocatable', active: true},

        {class_name: 'Facility', extension_name: 'TransamGeoLocatable', active: true},
        {class_name: 'RevenueVehicle', extension_name: 'TransamGeoLocatable', active: true},
        {class_name: 'ServiceVehicle', extension_name: 'TransamGeoLocatable', active: true},
        {class_name: 'CapitalEquipment', extension_name: 'TransamGeoLocatable', active: true},
        {class_name: 'FacilityComponent', extension_name: 'TransamGeoLocatable', active: true},

        {class_name: 'Facility', extension_name: 'TransamGeoJSONFeature', active: true},
        {class_name: 'RevenueVehicle', extension_name: 'TransamGeoJSONFeature', active: true},
        {class_name: 'ServiceVehicle', extension_name: 'TransamGeoJSONFeature', active: true},
        {class_name: 'CapitalEquipment', extension_name: 'TransamGeoJSONFeature', active: true},
        {class_name: 'FacilityComponent', extension_name: 'TransamGeoJSONFeature', active: true}
    ]

    system_config_extensions.each do |extension|
      SystemConfigExtension.create!(extension)
    end
  end
end