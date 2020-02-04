class AddLongLatQueryTool < ActiveRecord::DataMigration
  def up

    view_sql = <<-SQL
        CREATE OR REPLACE VIEW geometry_transam_assets_view AS
        SELECT transam_assets.id, X(geometry) as longitude, Y(geometry) as latitude
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
  end
end