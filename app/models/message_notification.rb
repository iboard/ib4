class MessageNotification < ActiveRecord::Base
  belongs_to  :user  # the receiver
  belongs_to  :message
  has_one     :sender, :through => :message, :foreign_key => :user_id
  
  named_scope :new_notifications, lambda {  {:conditions => "read_at is NULL", :order => :updated_at} }
  
  after_create  :send_notification_mail
  
  
  def send_notification_mail
    return unless user.send_mail_notifications
    Delayed::Job.enqueue(
       MessagePostman.new(self.id,I18n.translate(:user_sent_a_message, :sender => message.user.fullname))
    )
  end
end
