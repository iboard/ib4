# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# When emails have to be send it whith this Mailer Class.
class UserMailer < ActionMailer::Base
  
  default_url_options[:host] = "#{LOCALHOST_NAME}"  
  
  
  def password_reset_instructions(user,subject)
    subject     subject
    from        "noreply@#{default_url_options[:host]}"
    recipients  user.email
    sent_on     Time::now
    body        :edit_password_reset_url => edit_reset_password_url(user.perishable_token)
  end
  
  def new_account_instructions(user,subject)
    subject     subject
    from        "noreply@#{default_url_options[:host]}"
    recipients  user.email
    sent_on     Time::now
    body        :edit_password_reset_url => edit_reset_password_url(user.perishable_token)
  end

  def comment_notification(comment,t_subject,commentable_url)
    subject     t_subject
    from        comment.user.email
    recipients  comment.commentable.user.email
    sent_on     Time::now
    body        :comment => comment, :commentable_url => commentable_url
  end
  
end
