class GoogleMap < ActiveRecord::Base

  has_many :markers
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'

  order_by 'name'

  before_validation :create_point
  attr_accessor :latitude, :longitude

  validates_presence_of :name, :description, :center, :zoom, :latitude, :longitude, :message => 'required'
  validates_uniqueness_of :name, :message => 'name already in use'
  validates_numericality_of :zoom,  :only_integer => true,
                                    :allow_nil => true,
                                    :greater_than_or_equal_to => 0,
                                    :less_than_or_equal_to => 17,
                                    :message => 'must be an integer in the range 0 to 17 (inclusive)'  #:latitude, :longitude - Active record cannot validate_numericality_of non-db fields

  def self.generate_html(name, div,context)
    
    @stored_map = GoogleMap.find_by_name(name, :include => :markers)
    return "<p>No map found with the name '#{name}'</p>" if @stored_map == nil
    @map = GMap.new(div)
    @map.control_init(:large_map => true,:map_type => true)
	  @map.center_zoom_init([@stored_map.center.y,@stored_map.center.x],@stored_map.zoom)
    @context = PageContext.new(context)
    @parser = Radius::Parser.new(@context, :tag_prefix => 'r')
    @stored_map.markers.each do |marker|
      text = marker.content
      text = @parser.parse(text)
      text = marker.filter.filter(text) if marker.respond_to? :filter_id

	    @map.overlay_init GMarker.new([marker.position.y, marker.position.x],:title => marker.title, :info_window => text)
    end

    @map.to_html
  end

  def self.generate_admin_html(id)

    @stored_map = GoogleMap.find(id)
    @map = GMap.new('gmap')
    @map.control_init(:large_map => true,:map_type => true)
	  @map.center_zoom_init([@stored_map.center.y,@stored_map.center.x],@stored_map.zoom)

    @marker= GMarker.new([@stored_map.center.y,@stored_map.center.x],:title => "Drag me", :draggable => true)
    @map.overlay_global_init(@marker, "marker")
    @map.event_init(@marker,:dragend,'function() { var latlng = marker.getPoint(); $("marker_latitude").value = latlng.lat(); $("marker_longitude").value = latlng.lng(); }')
    @map.to_html
  end

  private

  def create_point
    self.center = Point.from_x_y(self.longitude,self.latitude, 4326)
  end

end
