class AddCounterCacheColumnsToPostings < ActiveRecord::Migration
  def self.up
    # POSTINGS
    add_column :postings, :group_restrictions_count, :integer, :default => 0
    add_column :postings, :comments_count, :integer, :default => 0
    Posting.reset_column_information  
    Posting.all.each do |p|  
      p.update_attribute :group_restrictions_count, p.group_restrictions.length || 0
      p.update_attribute :comments_count, p.comments.length || 0
      p.save
    end
    
    # PROJECTS
    add_column :projects, :group_restrictions_count, :integer, :default => 0
    Project.reset_column_information  
    Project.all.each do |p|  
      p.update_attribute :group_restrictions_count, p.group_restrictions.length || 0
      p.save
    end
    
    
  end

  def self.down
    remove_column :postings, :comments_count
    remove_column :postings, :group_restrictions_count
    remove_column :projects, :group_restrictions_count
  end
end
