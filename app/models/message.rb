class Message < ActiveRecord::Base
  belongs_to :user
  has_many   :message_notifications, :dependent => :delete_all
  has_many   :receivers, :through => :message_notifications, :foreign_key => :user_id
  
  validates_presence_of :message
  after_save  :send_notifications  
  
  def recipient_ids=(recipients)
    @recipients = recipients
    errors.add :recipients, t(:no_recipients)
  end
  
  def recipients
    message_notifications.map { |n| n.user }
  end
  
  
  private
  def send_notifications
    @recipients.uniq.each do |r|
      m = User.find(r).message_notifications.create(:message => self)
    end
  end
end
