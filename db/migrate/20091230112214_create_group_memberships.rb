class CreateGroupMemberships < ActiveRecord::Migration
  def self.up
    create_table :group_memberships do |t|
      t.integer :user_id
      t.integer :usergroup_id
      t.integer :assigned_by

      t.timestamps
    end
  end

  def self.down
    drop_table :group_memberships
  end
end
