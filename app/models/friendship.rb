class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"

  validates_uniqueness_of :friend_id, :scope => :user_id
  
  
  def friend_of(of_user)
    of_user == user ? friend : user
  end
  
end
