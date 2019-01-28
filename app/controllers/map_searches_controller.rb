class MapSearchesController < SearchesController
  skip_before_action :verify_authenticity_token
  before_action :set_view_vars,     :only => [:geojson]
  before_action :process_filters,     :only => [:geojson]


  # Called via AJAX to get markers for the search results
  def geojson
    #---------------------------------------------------------------------------
    # Update last modified header so content is never cached
    #---------------------------------------------------------------------------
    headers['Last-Modified'] = Time.now.httpdate 

    # exclude assets without geometry
    mappable_assets = @data.where("geometry is NOT NULL")

    resp_json = {}

    asset_type_layer_name = params[:searcher][:asset_type_layer_class_name] || 'AssetType'

    if params[:searcher] && !params[:searcher][asset_type_layer_name.foreign_key.to_sym].blank?
      asset_types = asset_type_layer_name.constantize.where(id: params[:searcher][asset_type_layer_name.foreign_key.to_sym])

      asset_types.each do |asset_type|
        if asset_type_layer_name == 'AssetType'
          assets = mappable_assets.where("transam_assets.asset_subtype_id": asset_type.asset_subtype_ids)
        else
          assets = mappable_assets.where(asset_type_layer_name.foreign_key.to_sym => asset_type)
        end
        resp_json[asset_type.id] = {
          name: asset_type.name,
          geojson_assets: geo_json(assets) 
        }
      end
    end

    respond_to do |format|
      format.js   { render json: resp_json }  # respond with the created JSON object
      format.json { render json: resp_json }  # respond with the created JSON object
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

    assets.very_specific.find_each do |asset|
      feat = asset.try(:to_geoJSON)
      if asset && asset.class.respond_to?(:default_map_renderer_attr)
        attr_name = asset.class.default_map_renderer_attr
        feat[:properties][attr_name] = asset.send(attr_name)
      end
      features << feat unless feat.blank?
    end

    geojson
  end

  def process_filters
    if params[:searcher].blank?
      @data = Rails.application.config.asset_base_class_name.safe_constantize.try(:none)
    else
      @searcher = @searcher_klass.constantize.new(params[:searcher])
      if @searcher.respond_to? :organization_id
        @searcher.organization_id = @organization_list
      end
      @searcher.user = current_user
      @data = @searcher.data
    end
  end

  private 

end
