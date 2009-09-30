class RemoveTagstringFromPostings < ActiveRecord::Migration
  def self.up
    remove_column :postings, :tagstring
  end

  def self.down
    add_column :postings, :tagstring, :string
  end
end
