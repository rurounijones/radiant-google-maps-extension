class Admin::MarkersController < Admin::ResourceController
  model_class Marker

  def index
    redirect_to admin_google_map_url(params[:google_map_id])
  end

  def show
    redirect_to admin_google_map_url(params[:google_map_id])
  end

  def new
    @google_map = GoogleMap.find(params[:google_map_id])
    @marker = Marker.new(nil)
  end

  def edit
    @google_map = GoogleMap.find(params[:google_map_id])
    @marker = @google_map.markers.find(params[:id])
  end

  def remove
    @google_map = GoogleMap.find(params[:google_map_id])
    @marker = @google_map.markers.find(params[:id])
  end
end