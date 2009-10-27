# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# The User-Class uses AuthLogic

class User < ActiveRecord::Base
  
  acts_as_authentic  # authlogic handles validation too
  has_attached_file :avatar, 
                    :styles => { 
                      :medium => "300x300>", :thumb => "100x100>", 
                      :avatar => "100x100#", :icon => "48x48#" 
                    }, 
                    :whiny_thumbnails => true
  
  has_many :postings
  has_many :pages
  has_many :comments
  
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id', :dependent => :delete_all
  has_many :received_invitations, :class_name => 'Invitation', :foreign_key => 'recipient_id',  :dependent => :delete_all
  
  has_many :friendships, :dependent => :delete_all
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id', :dependent => :delete_all
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  
  attr_accessible :username, :email, :password, :password_confirmation, :fullname, :avatar
 
  # list all friends of your friendships-list when they found in inverse_friendships too
  def commited_friendships
    return @commited_friendships if @commited_friendships
    @commited_friendships = friendships.all.reject { |r|
      inverse_friendships.find_by_user_id(r.friend_id).nil?
    }
    @commited_friendships
  end
  
  # list all friendships which are not found in inverse_friendships
  def not_commited_friendships
    return @not_commited_friendships if @not_commited_friendships
    @not_commited_friendships = friendships.all.reject { |r|
      ! inverse_friendships.find_by_user_id(r.friend_id).nil?
    }
    @not_commited_friendships
  end
  
  # list friendships which you have not accepted yet
  def not_confirmed_friendships
    return @not_confirmed_friendships if @not_confirmed_friendships
    @not_confirmed_friendships = inverse_friendships.all.reject { |r|
      ! friendships.find_by_friend_id(r.user_id).nil?
    }
    @not_confirmed_friendships
  end
 
  def display_name_and_user
    "#{fullname} (#{username})"
  end
  
  def is_admin?
    is_admin
  end

  def deliver_password_reset_instructions(subject)
    reset_perishable_token!  
    UserMailer.deliver_password_reset_instructions(self,subject)  
  end  
  
  def deliver_new_account_instructions(subject)
    reset_perishable_token!  
    UserMailer.deliver_new_account_instructions(self,subject)  
  end        
  
end
