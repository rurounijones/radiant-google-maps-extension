class AddZoomToMarker < ActiveRecord::Migration
  def self.up
    add_column :markers, :zoom, :integer

    Marker.find(:all, :include => :google_map).each do |marker|
      marker.longitude = marker.position.x
      marker.latitude = marker.position.y
      marker.zoom = marker.google_map.zoom
      marker.save!
    end
  end

  def self.down
      remove_column :markers, :zoom    
  end
end
