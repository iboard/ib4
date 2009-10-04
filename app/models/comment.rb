class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  
  
  def deliver_comment_notification(commentable_url)
    receiver = self.commentable.user
    sender   = self.user
    if receiver && sender
      UserMailer.deliver_comment_notification(sender,receiver,comment,commentable,commentable_url)
    end
  end
  
end
