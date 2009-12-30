class CreateGroupRestrictions < ActiveRecord::Migration
  def self.up
    create_table :group_restrictions do |t|
      t.string :restrictable_type
      t.integer :restrictable_id
      t.integer :usergroup_id

      t.timestamps
    end
  end

  def self.down
    drop_table :group_restrictions
  end
end
