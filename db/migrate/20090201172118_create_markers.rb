class CreateMarkers < ActiveRecord::Migration
  def self.up
    create_table :markers do |t|
      t.integer :google_map_id, :null => false
      t.string :name, :null => false
      t.string :title, :null => false
      t.string :content
      t.column "position", :point, :null => false, :srid => 4326, :with_z => false # 4326: WSG84
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :created_by_id
      t.integer :updated_by_id
    end
  end

  def self.down
    drop_table :markers
  end
end
