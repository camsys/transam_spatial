class AddSpatialEngineNameSystemConfigExtensions < ActiveRecord::DataMigration
  def up
    system_config_extensions = [
        {class_name: 'Organization', extension_name: 'TransamGeocodable', active: true},
        {class_name: 'Vendor', extension_name: 'TransamGeocodable', active: true},

        {class_name: 'TransamAsset', extension_name: 'TransamGeoJSONFeature', active: true}
    ]

    system_config_extensions.each do |config|
      SystemConfigExtension.find_by(config).update!(engine_name: 'spatial')
    end
  end
end