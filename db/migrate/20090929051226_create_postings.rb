class CreatePostings < ActiveRecord::Migration
  def self.up
    create_table :postings do |t|
      t.integer :user_id
      t.string :subject
      t.text :body
      t.string :tagstring
      t.timestamps
    end
  end
  
  def self.down
    drop_table :postings
  end
end
