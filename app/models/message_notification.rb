class MessageNotification < ActiveRecord::Base
  belongs_to  :user  # the receiver
  belongs_to  :message
  has_one     :sender, :through => :message, :foreign_key => :user_id
  
  named_scope :new_notifications, lambda {  {:conditions => "read_at is NULL", :order => :updated_at} }
  
end
