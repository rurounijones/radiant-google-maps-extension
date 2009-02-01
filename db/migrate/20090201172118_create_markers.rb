class CreateMarkers < ActiveRecord::Migration
  def self.up
    create_table :markers do |t|
      t.integer :google_map_id, :null => false
      t.string :name, :null => false
      t.string :title, :null => false
      t.string :content
      t.column "position", :point, :null => false
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :created_by
      t.integer :updated_by
    end
  end

  def self.down
    drop_table :markers
  end
end
