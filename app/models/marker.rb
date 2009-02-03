class Marker < ActiveRecord::Base

  belongs_to :google_map
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'

  order_by 'name'

  before_validation :create_point
  attr_accessor :latitude, :longitude

  validates_presence_of :name, :title, :latitude, :longitude, :message => 'required'
  validates_uniqueness_of :name, :message => 'name already in use'
  validates_length_of :filter_id, :maximum => 25, :allow_nil => true, :message => '%d-character limit'

  object_id_attr :filter, TextFilter

  private

  def create_point
    self.position = Point.from_x_y(self.longitude,self.latitude, 4326)
  end

end
