class GoogleMap < ActiveRecord::Base

  before_validation :create_point
  attr_accessor :latitude, :longitude

  validates_presence_of :name, :description, :center, :zoom, :latitude, :longitude
  validates_numericality_of :latitude, :longitude, :zoom
  

  private

  def create_point
    self.center = Point.from_x_y(self.latitude,self.longitude)
  end

end
