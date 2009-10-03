# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# The User-Class uses AuthLogic
class User < ActiveRecord::Base
  
  acts_as_authentic
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>", :avatar => "100x100#", :icon => "48x48#" }, :whiny_thumbnails => true
  
  has_many :postings
  attr_accessible :username, :email, :password, :password_confirmation, :fullname, :avatar
  
        
  def deliver_password_reset_instructions(subject)
    reset_perishable_token!  
    UserMailer.deliver_password_reset_instructions(self,subject)  
  end  
  
  def deliver_new_account_instructions(subject)
    reset_perishable_token!  
    UserMailer.deliver_new_account_instructions(self,subject)  
  end
  
  def is_admin?
    is_admin
  end
  
end
