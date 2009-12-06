## Drop this into a file in db/migrate ##
class AddMissingIndexes < ActiveRecord::Migration
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

    
    add_index :binaries, :user_id
    add_index :messages, :user_id
    add_index :comments, :user_id
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :newsletter_deliveries, :newsletter_issue_id
    add_index :newsletter_deliveries, :newsletter_subscription_id
    add_index :newsletter_issues, :newsletter_id
    add_index :friendships, :user_id
    add_index :friendships, :friend_id
    add_index :newsletter_subscriptions, :newsletter_id
    add_index :tags, [:tagable_id, :tagable_type]
    add_index :categorizables, [:categorizable_id, :categorizable_type]
    add_index :categorizables, :category_id
    add_index :pages, :user_id
    add_index :postings, :user_id
    add_index :invitations, :sender_id
    add_index :invitations, :recipient_id
    add_index :permalinks, [:linkable_id, :linkable_type]
    add_index :message_notifications, :user_id
    add_index :message_notifications, :message_id
  end
  
  def self.down
    remove_index :binaries, :user_id
    remove_index :messages, :user_id
    remove_index :comments, :user_id
    remove_index :comments, :column => [:commentable_id, :commentable_type]
    remove_index :newsletter_deliveries, :newsletter_issue_id
    remove_index :newsletter_deliveries, :newsletter_subscription_id
    remove_index :newsletter_issues, :newsletter_id
    remove_index :friendships, :user_id
    remove_index :friendships, :friend_id
    remove_index :newsletter_subscriptions, :newsletter_id
    remove_index :tags, :column => [:tagable_id, :tagable_type]
    remove_index :categorizables, :column => [:categorizable_id, :categorizable_type]
    remove_index :categorizables, :category_id
    remove_index :pages, :user_id
    remove_index :postings, :user_id
    remove_index :invitations, :sender_id
    remove_index :invitations, :recipient_id
    remove_index :permalinks, :column => [:linkable_id, :linkable_type]
    remove_index :message_notifications, :user_id
    remove_index :message_notifications, :message_id
  end
end
