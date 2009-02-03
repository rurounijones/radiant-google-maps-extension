class GoogleMap < ActiveRecord::Base

  has_many :markers
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'

  order_by 'name'

  before_validation :create_point
  attr_accessor :latitude, :longitude

  validates_presence_of :name, :description, :center, :zoom, :latitude, :longitude, :message => 'required'
  validates_uniqueness_of :name, :message => 'name already in use'
  validates_numericality_of :zoom, :message => 'must be a number'  #:latitude, :longitude - Active record cannot validate_numericality_of non-db fields
  
  def self.generate_html(name, div)
    
    @stored_map = GoogleMap.find_by_name(name, :include => :markers)
    return "<p>No map found with the name '#{name}'</p>" if @stored_map == nil
    @map = GMap.new(div)
    @map.control_init(:large_map => true,:map_type => true)
	  @map.center_zoom_init([@stored_map.center.y,@stored_map.center.x],@stored_map.zoom)

    @stored_map.markers.each do |marker|
	    @map.overlay_init GMarker.new([marker.position.y, marker.position.x],:title => marker.title, :info_window => marker.content)
    end

    @map.to_html
  end

  private

  def create_point
    self.center = Point.from_x_y(self.longitude,self.latitude, 4326)
  end

end
