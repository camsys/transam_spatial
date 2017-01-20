class MapOverlayServicesController < OrganizationAwareController

  before_action :set_service, only: [:edit, :update, :destroy, :activate]

  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'Overlay Services', :map_overlay_services_path

  authorize_resource

  def index
    @map_overlay_services = MapOverlayService.where("organization_id is NULL or organization_id in (?)", @organization_list)
  end

  def new
    add_breadcrumb "New Overlay Service"
    @map_overlay_service = MapOverlayService.new
  end

  def create
    add_breadcrumb "New Overlay Service"

    @map_overlay_service = MapOverlayService.new(service_params)
    @map_overlay_service.creator = current_user
    @map_overlay_service.active = true

    respond_to do |format|
      if @map_overlay_service.save
        notify_user :notice, 'Overlay service was successfully created.'
        format.html { redirect_to map_overlay_services_path }
        format.json { render :show, status: :created, location: map_overlay_services_path }
      else
        format.html { render :new }
        format.json { render json: @map_overlay_service.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    add_breadcrumb "Update #{@map_overlay_service}"
  end

  def update

    add_breadcrumb @map_overlay_service, map_overlay_service_path(@map_overlay_service)
    add_breadcrumb "Update"

    respond_to do |format|
      if @map_overlay_service.update(service_params)
        notify_user :notice, 'Overlay service was successfully updated.'
        format.html { redirect_to map_overlay_services_path }
        format.json { render :show, status: :ok, location: map_overlay_services_path }
      else
        format.html { render :edit }
        format.json { render json: @map_overlay_service.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @map_overlay_service.destroy
    respond_to do |format|
      notify_user :notice, 'Overlay service was successfully removed.'
      format.html { redirect_to map_overlay_services_path }
      format.json { head :no_content }
    end
  end

  private

  def set_service
    @map_overlay_service = MapOverlayService.find_by_object_key(params[:id])
    if @map_overlay_service.nil?
      redirect_to '/404'
      return
    end
  end

  def service_params
    params.require(:map_overlay_service).permit(MapOverlayService.allowable_params)
  end

end