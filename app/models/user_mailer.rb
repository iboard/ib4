# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# When emails have to be send it whith this Mailer Class.
class UserMailer < ActionMailer::Base
  
  default_url_options[:host] = "#{LOCALHOST_NAME}"  
  
  
  def password_reset_instructions(user,subject)
    subject     subject
    from        "noreply@#{LOCALHOST_NAME}"
    recipients  user.email
    sent_on     Time::now
    body        :edit_password_reset_url => edit_reset_password_url(user.perishable_token)
  end
  
  def new_account_instructions(user,subject)
    subject     subject
    from        "noreply@#{LOCALHOST_NAME}"
    recipients  user.email
    sent_on     Time::now
    body        :edit_password_reset_url => edit_reset_password_url(user.perishable_token)
  end
  
end
