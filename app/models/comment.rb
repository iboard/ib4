class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  
  delegate :list_title, :to => :commentable  
  delegate :read_allowed, :to => :commentable

  validates_presence_of :comment
  
  def deliver_comment_notification(t_subject,commentable_url)
    unless commentable.user.nil? || user.nil?
      UserMailer.deliver_comment_notification(self,t_subject,commentable_url)
    end
  end
  
  def rss_body
    comment.to_s
  end
  
end
