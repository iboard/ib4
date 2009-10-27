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
    content_type  "text/html"
  end
  
  def new_account_instructions(user,subject)
    subject     subject
    from        "noreply@#{default_url_options[:host]}"
    recipients  user.email
    sent_on     Time::now
    body        :edit_password_reset_url => edit_reset_password_url(user.perishable_token)
    content_type  "text/html"
  end

  def comment_notification(comment,t_subject,commentable_url)
    subject     t_subject
    from        comment.user.email
    recipients  comment.commentable.user.email
    sent_on     Time::now
    body        :comment => comment, :commentable_url => commentable_url
    content_type  "text/html"
  end
  
  def account_invitation(sender,t_recipient_email,t_subject,message,hostname,register_url,client_ip)
    subject     t_subject
    from        sender.email
    recipients  [t_recipient_email, sender.email]
    sent_on     Time::now
    body        :message => message, :sender => sender, :hostname => hostname, :register_url => register_url, :client_ip => client_ip
    content_type "text/html"
  end
   
  # Deliver Newsletter
  def newsletter(sender,to,title,subject_txt,header_image_tag,header,footer,body_html,url)
    recipients              to
    from                    sender
    subject                 subject_txt
    body                    :header_image_tag => header_image_tag, :header => header, :message => body_html, :footer => footer, :url => url
    content_type            "text/html"
  end
 
end
