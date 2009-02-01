class Marker < ActiveRecord::Base

  belongs_to :google_map

  before_validation :create_point
  attr_accessor :latitude, :longitude

  validates_presence_of :name, :title, :latitude, :longitude
  validates_uniqueness_of :name

  private

  def create_point
    self.position= Point.from_x_y(self.longitude,self.latitude)
  end

end
