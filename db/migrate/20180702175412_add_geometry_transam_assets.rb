class AddGeometryTransamAssets < ActiveRecord::Migration[5.2]
  def change
    add_column :transam_assets, :geometry, :geometry, after: :in_backlog
  end
end
