module TransamSpatialController
  extend ActiveSupport::Concern
  
  included do
          
  end

  #------------------------------------------------------------------------------
  #
  # Class Methods
  #
  #------------------------------------------------------------------------------

  module ClassMethods

  end

  #------------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #------------------------------------------------------------------------------

  # Implements a map view which includes spatial filtering
  def map

    # Set the view variables
    set_view_vars
    
    # get the list of assets to match the query
    @assets = get_assets

    markers = []
    @assets.each do |asset|
      if asset.mappable?
        markers << get_map_marker(asset, asset.object_key, false) # not draggable
      end
    end
    @markers = markers.to_json

    unless @fmt == 'xls'
      # cache the set of asset ids in case we need them later
      cache_list(@assets, INDEX_KEY_LIST_VAR)
    end

    respond_to do |format|
      format.html
      format.js
      format.json { render :json => get_as_json(@assets, @row_count) }
      format.xls
    end  
  end


  # Sets the spatial filter bounding box
  def spatial_filter

    # Check to see if we got spatial filter. If it is nil then spatial fitlering has been
    # diabled
    @spatial_filter = params[:spatial_filter]
    # store it in the session for later
    session[:spatial_filter] = @spatial_filter

  end

end      
