class AddLocationReferenceTransamAssets < ActiveRecord::Migration[5.2]
  def change
    if ActiveRecord::Base.connection.table_exists? :transam_assets
      add_column :transam_assets, :location_reference_type_id, :integer, after: :geometry
      add_column :transam_assets, :location_reference, :string, after: :location_reference_type_id
    end
  end
end
