class MapsController < AssetsController

  def index

    id_list = get_cached_objects(INDEX_KEY_LIST_VAR)
    @assets = Asset.where(:object_key => id_list)
    markers = []
    @assets.each do |a|
      asset = Asset.get_typed_asset(a)
      if asset.mappable?
        markers << asset.map_marker
      end
    end
    @markers = markers.to_json
    respond_to do |format|
      format.html
      format.json { render :json => @asset_id_list.to_json }
    end
  end

  # Called via Ajax to get the map marker for a selected asset
  # Asset is identified by its object key in the params hash
  def marker

    @marker = {}
    a = Asset.find_by(:object_key => params[:object_key])
    if a
      asset = Asset.get_typed_asset(a)
      if a.mappable?
        @marker = a.get_map_marker
      end
    end
  end

end
