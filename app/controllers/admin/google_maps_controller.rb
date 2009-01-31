class Admin::GoogleMapsController < ApplicationController

  def index
    @google_maps = GoogleMap.find(:all)
  end

  def new
    @google_map = GoogleMap.new()
  end

  def edit
    @google_map = GoogleMap.find(params[:id])
  end

  def create
    @google_map = GoogleMap.new(params[:google_map])

    respond_to do |format|
      if @google_map.save
        format.html { redirect_to( admin_google_maps_path ) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  

  def update
    @google_map = GoogleMap.update(params[:id],params[:google_map])

    respond_to do |format|
      if @google_map.save
        format.html { redirect_to( admin_google_maps_path ) }
      else
        format.html { render :action => "new" }
      end
    end
  end
 
end