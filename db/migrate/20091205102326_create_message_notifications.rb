class CreateMessageNotifications < ActiveRecord::Migration
  def self.up
    create_table :message_notifications do |t|
      t.integer :message_id
      t.integer :user_id
      t.datetime :read_at
      t.timestamps
    end
  end
  
  def self.down
    drop_table :message_notifications
  end
end
