class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :parent_id
      t.integer :user_id
      t.string :noteable_type
      t.integer :noteable_id
      t.text :message
      t.string :message_value
      t.string :message_type
      t.timestamps
    end
  end
  
  def self.down
    drop_table :notes
  end
end
