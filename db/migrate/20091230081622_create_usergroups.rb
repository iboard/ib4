class CreateUsergroups < ActiveRecord::Migration
  def self.up
    create_table :usergroups do |t|
      t.string :name
      t.integer :user_id
      t.integer :join_mask
      t.timestamps
    end
  end
  
  def self.down
    drop_table :usergroups
  end
end
