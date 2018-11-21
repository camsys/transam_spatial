class AddSpatialSystemConfigExtensions < ActiveRecord::DataMigration
  def up
    system_config_extensions = [
        {class_name: 'Organization', extension_name: 'TransamGeocodable', active: true},
        {class_name: 'Vendor', extension_name: 'TransamGeocodable', active: true},

        {class_name: 'TransamAsset', extension_name: 'TransamGeoJSONFeature', active: true},
    ]

    system_config_extensions.each do |extension|
      SystemConfigExtension.create!(extension)
    end
  end
end