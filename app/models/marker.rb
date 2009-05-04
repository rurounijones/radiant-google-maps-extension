class Marker < ActiveRecord::Base

  belongs_to :google_map
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'

  order_by 'name'

  before_validation :create_point
  attr_accessor :latitude, :longitude

  validates_presence_of :name, :title, :latitude, :longitude, :google_map_id, :position, :zoom, :message => 'required'
  validates_numericality_of :google_map_id, :only_integer=> true, :allow_nil => true, :message => "must be a number"
  validates_uniqueness_of :name, :scope => :google_map_id, :message => 'name already in use'
  validates_length_of :filter_id, :maximum => 25, :allow_nil => true, :message => '%d-character limit'
  validates_numericality_of :zoom,  :only_integer => true,
                                    :allow_nil => true,
                                    :greater_than_or_equal_to => 0,
                                    :less_than_or_equal_to => 17,
                                    :message => 'must be an integer in the range 0 to 17 (inclusive)'  #:latitude, :longitude - Active record cannot validate_numericality_of non-db fields

  object_id_attr :filter, TextFilter

  private

  def create_point
    self.position = Point.from_x_y(self.longitude,self.latitude, 4326)
  end

end
