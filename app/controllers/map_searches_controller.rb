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
    
    @geojson = {
      "type":"FeatureCollection",
      "features": []
    }   

    # exclude assets without geometry
    mappable_assets = @data.where("geometry is NOT NULL")

    @geojson = geo_json(mappable_assets) 

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

    assets.find_each do |asset|
      str = asset.try(:to_geoJSON)
      features << str unless str.blank?
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
