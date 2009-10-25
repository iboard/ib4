class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"

  validates_uniqueness_of :friend_id, :scope => :user_id  
end
