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
  
  def comment_notification(sender,receiver,comment,commentable,commentable_url)
    subject     t(:commentable_commented, :title => commentable.list_title, :username => sender.username)
    from        sender.email
    recipients  receiver.email
    sent_on     Time::now
    body        :commentable => commentable, :comment => comment, :sender => sender, :commentable_url => commentable_url
  end
  
end
