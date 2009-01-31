class Admin::GoogleMapsController < ApplicationController

  def index
    @google_maps = GoogleMap.find(:all)
  end
end