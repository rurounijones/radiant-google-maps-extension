class Admin::MarkersController < Admin::ResourceController
  model_class Marker

  responses do |r|
    r.destroy.default { redirect_to admin_google_map_url(params[:google_map_id]) }
  end

  def index
    redirect_to admin_google_map_url(params[:google_map_id])
  end

  def show
    redirect_to admin_google_map_url(params[:google_map_id])
  end

  protected

  def model_class
    @google_map = GoogleMap.find(params[:google_map_id])
    @google_map.markers
  end

  def continue_url(options)
    options[:redirect_to] || (params[:continue] ? {:action => 'edit', :id => model.id} : admin_google_map_url(params[:google_map_id]))
  end


end