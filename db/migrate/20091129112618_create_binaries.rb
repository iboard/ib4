class CreateBinaries < ActiveRecord::Migration
  def self.up
    create_table :binaries do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.string :filename
      t.string :mime_type
      t.integer :filesize
      t.integer :access_mask
      t.timestamps
    end
  end
  
  def self.down
    drop_table :binaries
  end
end
