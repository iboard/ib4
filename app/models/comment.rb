class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  
  
  def deliver_comment_notification(t_subject,commentable_url)
    unless commentable.user.nil? || user.nil?
      UserMailer.deliver_comment_notification(self,t_subject,commentable_url)
    end
  end
  
end
