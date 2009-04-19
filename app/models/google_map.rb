class GoogleMap < ActiveRecord::Base

  has_many :markers
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'

  order_by 'name'

  before_validation :create_point
  attr_accessor :latitude, :longitude

  validates_presence_of :name, :description, :center, :zoom, :latitude, :longitude, :style,  :message => 'required'
  validates_uniqueness_of :name, :message => 'name already in use'
  validates_numericality_of :zoom,  :only_integer => true,
                                    :allow_nil => true,
                                    :greater_than_or_equal_to => 0,
                                    :less_than_or_equal_to => 17,
                                    :message => 'must be an integer in the range 0 to 17 (inclusive)'  #:latitude, :longitude - Active record cannot validate_numericality_of non-db fields

  VALID_MAP_TYPE_NAMES = {
  "Normal Map" => 1,
  "Satellite Map" => 2,
  "Hybrid Map" => 3
  }

  VALID_MAP_TYPES = {
  GMapType::G_NORMAL_MAP => 1,
  GMapType::G_SATELLITE_MAP => 2,
  GMapType::G_HYBRID_MAP => 3
  }



  def self.generate_html(div,id,name,marker_id,marker_name,context)
    
    begin
      @stored_map = id ? GoogleMap.find(id, :include => :markers) : GoogleMap.find_by_name(name, :include => :markers)
    rescue
      return "<p>Map with id '#{id}' not found</p>"
    end
    return "<p>Map with name '#{name}' not found</p>" if @stored_map == nil

    
    if marker_id || marker_name
      begin
        @main_marker = marker_id ? @stored_map.markers.find(marker_id) : @stored_map.markers.find_by_name(marker_name)
      rescue
        return "<p>Marker with id '#{marker_id}' not found</p>"
      end
      return "<p>Marker with name '#{marker_name}' not found</p>" if @main_marker.nil?
    end

    @map = GMap.new(div)
    @map.set_map_type_init(VALID_MAP_TYPES.index(@stored_map.style))
    @map.control_init(:large_map => true,:map_type => true)
    if @main_marker
      @map.center_zoom_init([@main_marker.position.y,@main_marker.position.x],@stored_map.zoom)
    else
      @map.center_zoom_init([@stored_map.center.y,@stored_map.center.x],@stored_map.zoom)
    end

    @context = PageContext.new(context)
    @parser = Radius::Parser.new(@context, :tag_prefix => 'r')
    @stored_map.markers.each do |marker|
      text = marker.content
      text = @parser.parse(text)
      text = marker.filter.filter(text) if marker.respond_to? :filter_id
      text.gsub!('/', '\/')

	    @map.overlay_init GMarker.new([marker.position.y, marker.position.x],:title => marker.title, :info_window => text)
    end

    @map.to_html
  end

  def self.generate_admin_google_map_html(id)

    @map = GMap.new('gmap')
    begin
      @stored_map = GoogleMap.find(id)
    rescue ActiveRecord::RecordNotFound
      @stored_map = GoogleMap.new()
      @stored_map.center = Point.from_x_y(0,0, 4326)
      @stored_map.zoom = 3
    end

    @map.set_map_type_init(VALID_MAP_TYPES.index(@stored_map.style))

	  @map.center_zoom_init([@stored_map.center.y,@stored_map.center.x],@stored_map.zoom)
    @map.interface_init(:double_click_zoom => false, :scroll_wheel_zoom => false)
    @map.control_init(:admin_map => true, :map_type => true)

    @marker= GMarker.new([@stored_map.center.y,@stored_map.center.x],:title => "Map Center", :draggable => true)
    @map.overlay_global_init(@marker, "marker")      

    #@map.event_init(@map, :dragend, 'function() { var latlng = map.getCenter() ; marker.setPoint(latlng); $("google_map_latitude").value = latlng.lat(); $("google_map_longitude").value = latlng.lng();}' )
    @map.event_init(@map, 'singlerightclick', 'function(pixel,url,obj) { var latlng = map.fromContainerPixelToLatLng(pixel); map.panTo(latlng); marker.setPoint(latlng); $("google_map_latitude").value = latlng.lat(); $("google_map_longitude").value = latlng.lng();}' )
    @map.event_init(@marker,:dragend,'function() { var latlng = marker.getPoint(); $("google_map_latitude").value = latlng.lat(); $("google_map_longitude").value = latlng.lng(); map.panTo(latlng); }')
    
    @map.to_html
  end

  def self.generate_admin_google_map_marker_html(id)

    @stored_map = GoogleMap.find(id)
    @map = GMap.new('gmap')
    @map.set_map_type_init(VALID_MAP_TYPES.index(@stored_map.style))
    @map.control_init(:large_map => true,:map_type => true)
	  @map.center_zoom_init([@stored_map.center.y,@stored_map.center.x],@stored_map.zoom)

    @marker= GMarker.new([@stored_map.center.y,@stored_map.center.x],:title => "Drag me", :draggable => true)
    @map.overlay_global_init(@marker, "marker")

    @map.event_init(@map, 'singlerightclick', 'function(pixel,url,obj) { var latlng = map.fromContainerPixelToLatLng(pixel); map.panTo(latlng); marker.setPoint(latlng); $("google_map_latitude").value = latlng.lat(); $("google_map_longitude").value = latlng.lng();}' )
    @map.event_init(@marker,:dragend,'function() { var latlng = marker.getPoint(); $("marker_latitude").value = latlng.lat(); $("marker_longitude").value = latlng.lng(); }')
  
    @map.to_html
  end

  private

  def create_point
    self.center = Point.from_x_y(self.longitude,self.latitude, 4326)
  end

end
