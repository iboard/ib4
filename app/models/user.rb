class User < ActiveRecord::Base
  acts_as_authentic
  
  def deliver_password_reset_instructions!(subject)
    reset_perishable_token!  
    UserMailer.deliver_password_reset_instructions(self,subject)  
  end  
  
  def deliver_new_account_instructions!(subject)
    reset_perishable_token!  
    UserMailer.deliver_new_account_instructions(self,subject)  
  end
  
  def is_admin?
    username == 'root'
  end
  
end
