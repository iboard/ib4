class AddDraftToPostings < ActiveRecord::Migration
  def self.up
    add_column :postings, :draft, :boolean, :default => false
  end

  def self.down
    remove_column :postings, :draft
  end
end
