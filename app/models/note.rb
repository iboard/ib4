class Note < ActiveRecord::Base
  
  MESSAGE_TYPES = [ :new_action, :update_action, :end_action, :user_string ]
  
  acts_as_tree
  
  belongs_to  :user
  belongs_to  :noteable, :polymorphic => true
  serialize   :message_type
  serialize   :message_value
  
  validates_presence_of :message
  
end
