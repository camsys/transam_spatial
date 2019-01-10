class MapSearchesController < SearchesController
  skip_before_action :verify_authenticity_token
  before_action :set_view_vars,     :only => [:geojson]


  # Called via AJAX to get markers for the search results
  def geojson
    #---------------------------------------------------------------------------
    # Update last modified header so content is never cached
    #---------------------------------------------------------------------------
    headers['Last-Modified'] = Time.now.httpdate

    @asset_subtype = AssetSubtype.where(id: params[:searcher][:asset_subtype_id]).first
    @asset_type = @asset_subtype.present? ? @asset_subtype.asset_type : AssetType.where(id: params[:searcher][:asset_type_id]).first

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
    @searcher = @searcher_klass.constantize.new(params[:searcher])
    if @searcher.respond_to? :organization_id
      @searcher.organization_id = @organization_list
    end
    @searcher.user = current_user
    @data = @searcher.data
  end

  private 

end
