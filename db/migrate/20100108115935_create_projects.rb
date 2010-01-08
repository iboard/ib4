class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.integer :page_id
      t.integer :user_id
      t.integer :status
      t.integer :access_mask
      t.timestamps
    end
  end
  
  def self.down
    drop_table :projects
  end
end
