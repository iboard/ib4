## Drop this into a file in db/migrate ##
class AddNewIndexes < ActiveRecord::Migration
  def self.up
    
    # These indexes were found by searching for AR::Base finds on your application
    # It is strongly recommanded that you will consult a professional DBA about your infrastucture and implemntation before
    # changing your database in that matter.
    # There is a possibility that some of the indexes offered below is not required and can be removed and not added, if you require
    # further assistance with your rails application, database infrastructure or any other problem, visit:
    #
    # http://www.railsmentors.org
    # http://www.railstutor.org
    # http://guides.rubyonrails.org

    
    add_index :notes, :user_id
    add_index :notes, [:noteable_id, :noteable_type]
    add_index :notes, :parent_id
    add_index :pages, :parent_id
    add_index :group_restrictions, [:restrictable_id, :restrictable_type]
    add_index :group_restrictions, :usergroup_id
    add_index :group_memberships, :user_id
    add_index :group_memberships, :usergroup_id
    add_index :usergroups, :user_id
  end
  
  def self.down
    remove_index :notes, :user_id
    remove_index :notes, :column => [:noteable_id, :noteable_type]
    remove_index :notes, :parent_id
    remove_index :pages, :parent_id
    remove_index :group_restrictions, :column => [:restrictable_id, :restrictable_type]
    remove_index :group_restrictions, :usergroup_id
    remove_index :group_memberships, :user_id
    remove_index :group_memberships, :usergroup_id
    remove_index :usergroups, :user_id
  end
end
