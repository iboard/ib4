class MessagePostman < Struct.new(:message_notification_id,:subject_txt)
  def perform
    notify = MessageNotification.find(message_notification_id)
    
    UserMailer.deliver_message_notification(
       notify.message.user.email,
       notify.user.email,
       subject_txt,
       notify.message.message,
       "#{ROOT_URL}#{notify.message.user.avatar.url(:avatar)}",
       notify.user.id.to_s
    ) 
  end
end
