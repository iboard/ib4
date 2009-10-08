class CreatePermalinks < ActiveRecord::Migration
  def self.up
    create_table :permalinks do |t|
      t.integer :linkable_id
      t.string :linkable_type
      t.string :url
      t.timestamps
    end
  end
  
  def self.down
    drop_table :permalinks
  end
end
