class MapSearchesController < SearchesController

  # Called via AJAX to get markers for the search results
  def map
    @searcher_klass = "AssetSearcher"

    # use organization list if query is for any organization
    params[:searcher][:organization_id] = @organization_list if params[:searcher][:organization_id] == [''] || params[:searcher][:organization_id].nil?

    @searcher = @searcher_klass.constantize.new(params[:searcher])
    @searcher.user = current_user
    @data = @searcher.data

    render json: @data.to_json
  end

end
