class GoogleMapsExtension < Radiant::Extension
  version "1.3.1"
  description "Allows you to embed google maps in your site"
  url "http://github.com/rurounijones/radiant-google-maps-extension/"
  
  define_routes do |map|
    map.namespace :admin, :member => { :remove => :get } do |admin|
      admin.resources :google_maps do |google_map|
        google_map.resources :markers, :member => { :remove => :get }
      end
    end
  end
  
  def activate
    admin.tabs.add "Maps", "/admin/google_maps", :after => "Layouts", :visibility => [:all]
    Page.send :include, GoogleMapsTags
    UserActionObserver.instance.send :add_observer!, GoogleMap
    UserActionObserver.instance.send :add_observer!, Marker
  end
  
  def deactivate
    # admin.tabs.remove "Maps"
  end
  
end
