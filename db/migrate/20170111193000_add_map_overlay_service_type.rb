class AddMapOverlayServiceType < ActiveRecord::Migration[4.2]
  def change
    unless table_exists? :map_overlay_service_types
      create_table :map_overlay_service_types do |t|
        t.string :code
        t.string :name

        t.timestamps
      end
    end
  end
end
