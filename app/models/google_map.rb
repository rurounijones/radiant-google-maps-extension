class GoogleMap < ActiveRecord::Base

  before_validation :create_point
  attr_accessor :latitude, :longitude

  validates_presence_of :name, :description, :center, :zoom, :latitude, :longitude
  validates_uniqueness_of :name
  validates_numericality_of :zoom #:latitude, :longitude - Active record cannot validate_numericality_of non-db fields
  

  private

  def create_point
    self.center = Point.from_x_y(self.latitude,self.longitude)
  end

end
