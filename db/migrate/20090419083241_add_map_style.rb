class AddMapStyle < ActiveRecord::Migration
  def self.up
      add_column :google_maps, :style, :integer
      GoogleMap.update_all( "style = 1")
  end

  def self.down
      remove_column :google_maps, :style
  end
end
