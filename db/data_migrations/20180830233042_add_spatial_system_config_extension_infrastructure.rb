class AddSpatialSystemConfigExtensionInfrastructure < ActiveRecord::DataMigration
  def up
    SystemConfigExtension.create!({class_name: 'Infrastructure', extension_name: 'TransamCoordinateLocatable', active: true})
  end
end