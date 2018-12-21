class MapSearchesController < SearchesController

  # Called via AJAX to get markers for the search results
  def geojson
    #---------------------------------------------------------------------------
    # Update last modified header so content is never cached
    #---------------------------------------------------------------------------
    headers['Last-Modified'] = Time.now.httpdate

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



      if asset_class
        if asset_class.respond_to?(:_geolocatable_geometry_attribute_name)
          geom_attr_name = asset_class._geolocatable_geometry_attribute_name
        else
          asset_class = asset_class.acting_as_model
          while asset_class
            if asset_class.respond_to?(:_geolocatable_geometry_attribute_name)
              geom_attr_name = asset_class._geolocatable_geometry_attribute_name
              asset_class = nil
            else
              asset_class = asset_class.acting_as_model
            end
          end
        end
      end
    end
    
    if geom_attr_name.present?
      process_filters

      mappable_assets = @data.where("#{geom_attr_name} is NOT NULL")

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
      asset = Rails.application.config.asset_base_class_name.constantize.get_typed_asset a
      str = asset.to_geoJSON
      features << str unless str.blank?
    end

    geojson
  end

  def process_filters
    search_params = params[:searcher]

     # TODO: depends on future changes in the generic query and map query, might need to re-use AssetSearcher for map search as well
    @data = Rails.application.config.asset_base_class_name.constantize.operational.includes(asset_subtype: :asset_type).where(
      organization_id: @organization_list, 
      asset_types: {id: search_params[:asset_type_id]},
      asset_subtype_id: search_params[:asset_subtype_id])

    [:reported_condition_rating, :scheduled_replacement_year, :purchase_year].each do |attr_key|
      check_attribute_range(attr_key)
    end

    if @asset_type && (@asset_type.class_name.include? 'Vehicle')
      check_attribute_range(:reported_mileage)
    end
  end

  def check_attribute_range(attr_key)
    search_params = params[:searcher]

    attr_from_key = "#{attr_key}_from".to_sym
    attr_to_key = "#{attr_key}_to".to_sym

    if attr_key.to_s == 'purchase_year'
      column = 'purchase_date'
    else
      column = attr_key
    end

    if search_params[attr_from_key].present?
      @data = @data.where("#{column} >= ?", search_params[attr_from_key])
    end
    if search_params[attr_to_key].present?
      @data = @data.where("#{column} <= ?", search_params[attr_to_key])
    end
  end

end
