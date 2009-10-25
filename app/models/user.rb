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
  
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id', :dependent => :delete_all
  has_many :received_invitations, :class_name => 'Invitation', :foreign_key => 'recipient_id',  :dependent => :delete_all
  
  has_many :friendships, :dependent => :delete_all
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id', :dependent => :delete_all
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  
  attr_accessible :username, :email, :password, :password_confirmation, :fullname, :avatar
 
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
