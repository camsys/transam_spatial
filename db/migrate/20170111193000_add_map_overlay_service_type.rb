class AddMapOverlayServiceType < ActiveRecord::Migration
  def change
    create_table :map_overlay_service_types do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
