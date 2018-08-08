class AddGeometryTransamAssets < ActiveRecord::Migration[5.2]
  def change
    if ActiveRecord::Base.connection.table_exists? :transam_assets
      add_column :transam_assets, :geometry, :geometry, after: :in_backlog
    end
  end
end
