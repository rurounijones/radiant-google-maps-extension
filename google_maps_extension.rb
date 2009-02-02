# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class GoogleMapsExtension < Radiant::Extension
  version "0.1"
  description "Allows you to embed google maps in your site"
  url "http://github.com/rurounijones/radiant-google-maps-extension/"
  
  # define_routes do |map|
  #   map.namespace :admin, :member => { :remove => :get } do |admin|
  #     admin.resources :google_maps
  #   end
  # end
  
  def activate
    admin.tabs.add "Maps", "/admin/google_maps", :after => "Layouts", :visibility => [:all]
    Page.send :include, GoogleMapsTags
    UserActionObserver.instance.send :add_observer!, GoogleMap
  end
  
  def deactivate
    # admin.tabs.remove "Maps"
  end
  
end
