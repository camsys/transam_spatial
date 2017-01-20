class SeedMapOverlayServiceTypeData < ActiveRecord::Migration
  def change
    if table_exists? :map_overlay_service_types
        data = {
          'esri_map': 'Esri Map Service',
          'esri_feature': 'Esri Feature Service'
        }

        data.each do |code, name|
          MapOverlayServiceType.where(code: code, name: name).first_or_create
        end
    end
  end
end
