class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.integer :tagable_id
      t.string :tagable_type
      t.string :name
      t.string :color
      t.string :background
      t.timestamps
    end
  end
  
  def self.down
    drop_table :tags
  end
end
