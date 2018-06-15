Rails.application.config.max_num_map_objects = 1000

if defined?(RGeo)
  RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |config|
    # By default, use the GEOS implementation for spatial columns.
    config.default = RGeo::Geos.factory_generator

    # But use a geographic implementation for point columns.
    config.register(Rails.application.config.rgeo_factory, geo_type: "geometry")
  end
end