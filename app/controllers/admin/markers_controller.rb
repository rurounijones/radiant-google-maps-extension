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

  def create
    @google_map = GoogleMap.find(params[:google_map_id])
    @marker = Marker.new(nil)
    @marker.update_attributes!(params[:marker])
    announce_saved
    response_for :create
  end

  def edit
    @google_map = GoogleMap.find(params[:google_map_id])
    @marker = @google_map.markers.find(params[:id])
  end

  def update
    @google_map = GoogleMap.find(params[:google_map_id])
    @marker = @google_map.markers.find(params[:id])
    @marker.update_attributes!(params[:marker])
    announce_saved
    response_for :update
  end

  def remove
    @google_map = GoogleMap.find(params[:google_map_id])
    @marker = @google_map.markers.find(params[:id])
  end
end