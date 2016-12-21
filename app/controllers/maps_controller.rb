class MapsController < AssetsController

  # Called via Ajax to get the map marker for a selected asset
  # Asset is identified by its object key in the params hash
  def marker

    @marker = {}
    a = Asset.find_by(:object_key => params[:object_key])
    if asset
      asset = Asset.get_typed_asset(a)
      if asset.mappable?
        @marker = asset.get_map_marker
      end
    end
  end

  # Called via AJAX to get dynamic content via AJAX
  def map_popup
    str = ""
    a = Asset.find_by(:object_key => params[:id])
    if a
      asset = Asset.get_typed_asset(a)
      if asset.mappable?
        str = render_to_string(:partial => "/shared/map_popup", :locals => { :asset => asset })
      end
    end

    render json: str.to_json
  end

end
