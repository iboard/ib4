class AddInvitationsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :invitations_left, :integer, :default => 0
  end

  def self.down
    remove_column :users, :invitations_left
  end
end
