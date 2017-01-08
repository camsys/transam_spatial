class MapSearchesController < SearchesController

  skip_before_filter  :verify_authenticity_token, only: [:map]

  # Called via AJAX to get markers for the search results
  def map
    @searcher_klass = "AssetSearcher"

    @asset_type = AssetType.where(id: params[:searcher][:asset_type_id]).first
    @asset_subtype = AssetSubtype.where(id: params[:searcher][:asset_subtype_id]).first

    @layer_name = if @asset_type && @asset_subtype
      "#{@asset_type} - #{@asset_subtype}"
    elsif @asset_type
      "#{@asset_type}"
    elsif @asset_subtype
      "#{@asset_subtype}"
    else
      "Assets"
    end

    # use organization list if query is for any organization
    params[:searcher][:organization_id] = @organization_list if params[:searcher][:organization_id] == [''] || params[:searcher][:organization_id].nil?

    @searcher = @searcher_klass.constantize.new(params[:searcher])
    @searcher.user = current_user
    @data = @searcher.data.limit(100) #TODO: remove 100 limit after query form design is ready

    markers = []
    @data.find_each do |a|
      asset = Asset.get_typed_asset(a)
      if asset.mappable?
        markers << asset.map_marker_without_popup
      end
    end

    @markers = markers.to_json   
  end

end
