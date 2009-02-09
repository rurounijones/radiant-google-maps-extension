class Admin::GoogleMapsController < Admin::ResourceController
  model_class GoogleMap

  def show
    @google_map = GoogleMap.find(params[:id], :include => [:markers])
  end

end