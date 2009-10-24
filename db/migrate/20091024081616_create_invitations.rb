class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.string :token
      t.string :recipient_email
      t.text :message
      t.integer :state
      t.timestamps
    end
  end
  
  def self.down
    drop_table :invitations
  end
end
