class AddMapOverlayServices < ActiveRecord::Migration
  def change
    unless table_exists? :map_overlay_services
      create_table :map_overlay_services do |t|
        t.string :object_key, null: false, length: 12
        t.integer :organization_id, index: true
        t.integer :created_by_user_id, index: true
        t.integer :map_overlay_service_type_id, index: true
        t.string :name
        t.string :url
        t.boolean :active

        t.timestamps
      end
    end
  end
end
