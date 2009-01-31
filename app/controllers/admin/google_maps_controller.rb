class Admin::GoogleMapsController < ApplicationController

  def index
    @gmaps = GoogleMap.find(:all)
  end
end
