class MapSearchesController < SearchesController

  skip_before_filter  :verify_authenticity_token, only: [:geojson]

  # Called via AJAX to get markers for the search results
  def geojson
    #---------------------------------------------------------------------------
    # Update last modified header so content is never cached
    #---------------------------------------------------------------------------
    headers['Last-Modified'] = Time.now.httpdate

    @searcher_klass = "AssetSearcher"

    @asset_subtype = AssetSubtype.where(id: params[:searcher][:asset_subtype_id]).first
    @asset_type = @asset_subtype.present? ? @asset_subtype.asset_type : AssetType.where(id: params[:searcher][:asset_type_id]).first

    @layer_name = if @asset_type && @asset_subtype
      "#{@asset_type} - #{@asset_subtype}"
    elsif @asset_type
      "#{@asset_type}"
    elsif @asset_subtype
      "#{@asset_subtype}"
    else
      "Assets"
    end

    @geojson = {
      "type":"FeatureCollection",
      "features": []
    }

    # get the geometry column name associated with the assets
    if @asset_type
      asset_class = @asset_type.class_name.try(:constantize)
      if asset_class && asset_class.respond_to?(:_geolocatable_geometry_attribute_name)
        geom_attr_name = asset_class._geolocatable_geometry_attribute_name
      end
    end
    
    if geom_attr_name.present?
      # use organization list if query is for any organization
      params[:searcher][:organization_id] = @organization_list if params[:searcher][:organization_id] == [''] || params[:searcher][:organization_id].nil?

      searcher = @searcher_klass.constantize.new(params[:searcher])
      searcher.user = current_user
      data = searcher.data
      mappable_assets = data.where("#{geom_attr_name} is NOT NULL")

      @geojson = geo_json(mappable_assets) 
    end

    respond_to do |format|
      format.js   { render json: @geojson }  # respond with the created JSON object
      format.json { render json: @geojson }  # respond with the created JSON object
    end
  end

  private

  def geo_json(assets)
    #---------------------------------------------------------------------------
    # Return the results as a geoJSON feature collection
    #---------------------------------------------------------------------------
    features = []
    geojson = {
      type: "FeatureCollection",
      features: features
    }
    assets.find_each do |a|
      asset = Asset.get_typed_asset a
      str = asset.to_geoJSON
      features << str unless str.blank?
    end

    geojson
  end

end
