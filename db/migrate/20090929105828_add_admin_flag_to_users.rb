class AddAdminFlagToUsers < ActiveRecord::Migration
  def self.up
      add_column :users, :is_admin, :boolean, :default => false, :null => false
      add_column :users, :fullname, :string
  end

  def self.down
    remove_column :users, :is_admin
    remove_column :users, :fullname
  end
end
