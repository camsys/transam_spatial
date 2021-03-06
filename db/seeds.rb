#encoding: utf-8

# determine if we are using postgres or mysql
is_mysql = (ActiveRecord::Base.configurations[Rails.env]['adapter'].include? 'mysql2')
is_sqlite =  (ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'sqlite3')

#------------------------------------------------------------------------------
#
# Lookup Tables
#
# These are the lookup tables for TransAM Spatial
#
#------------------------------------------------------------------------------

puts "======= Processing TransAM Spatial Lookup Tables  ======="


location_reference_types = [
  #{:active => 1, :name => 'Well Known Text',        :format => "WELL_KNOWN_TEXT", :description => 'Location is determined by a well known text (WKT) string.'},
  #{:active => 1, :name => 'Route/Milepost/Offset',  :format => "LRS",             :description => 'Location is determined by a route milepost and offset.'},
  {:active => 1, :name => 'Street Address',         :format => "ADDRESS",         :description => 'Location is determined by a geocoded street address.'},
  {:active => 1, :name => 'Map Location',           :format => "COORDINATE",      :description => 'Location is determined by deriving a location from a map.'},
  {:active => 1, :name => 'Derived',                :format => "DERIVED",         :description => 'Location is determined by deriving a location from releated spatial objects.'},
  #{:active => 1, :name => 'GeoServer',              :format => "GEOSERVER",       :description => 'Location is determined by deriving a location from Geo Server.'},
  {:active => 1, :name => 'Undefined',              :format => "NULL",            :description => 'Location is not defined.'}
]
map_overlay_service_types = [
  {:code => 'esri_map', :name => 'Esri Map Service'},
  {:code => 'esri_feature', :name => 'Esri Feature Service'}
]

system_config_extensions = [
    {engine_name: 'spatial', class_name: 'Organization', extension_name: 'TransamGeocodable', active: true},
    {engine_name: 'spatial', class_name: 'Vendor', extension_name: 'TransamGeocodable', active: true},

    {engine_name: 'spatial', class_name: 'TransamAsset', extension_name: 'TransamGeoJSONFeature', active: true}
]

lookup_tables = %w{ location_reference_types map_overlay_service_types }

lookup_tables.each do |table_name|
  puts "  Loading #{table_name}"
  if is_mysql
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name};")
  elsif is_sqlite
    ActiveRecord::Base.connection.execute("DELETE FROM #{table_name};")
  else
    ActiveRecord::Base.connection.execute("TRUNCATE #{table_name} RESTART IDENTITY;")
  end
  data = eval(table_name)
  klass = table_name.classify.constantize
  data.each do |row|
    x = klass.new(row)
    x.save!
  end
end

merge_tables = %w{ system_config_extensions }

merge_tables.each do |table_name|
  puts "  Merging #{table_name}"
  data = eval(table_name)
  begin
    klass = table_name.classify.constantize
    data.each do |row|
      x = klass.new(row)
      x.save!
    end
  rescue NameError
  end
end

puts "======= Loading spatial asset query configurations ======="
view_sql = <<-SQL
          CREATE OR REPLACE VIEW geometry_transam_assets_view AS
          SELECT transam_assets.id, ST_X(geometry) as longitude, ST_Y(geometry) as latitude
          FROM transam_assets
SQL

ActiveRecord::Base.connection.execute view_sql

ac = QueryAssetClass.find_or_create_by(table_name: 'geometry_transam_assets_view', transam_assets_join: 'LEFT JOIN geometry_transam_assets_view ON geometry_transam_assets_view.id = transam_assets.id')

[{
     name: 'longitude',
     label: 'Longitude',
     filter_type: 'text'
 },
 {
     name: 'latitude',
     label: 'Latitude',
     filter_type: 'text'
 }
].each do |query_field_params|
  query_field = QueryField.create!(query_field_params.merge(query_category: QueryCategory.find_by(name: 'Identification & Classification')))

  query_field.query_asset_classes << ac
end
