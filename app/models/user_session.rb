class UserSession < Authlogic::Session::Base
  after_create   :create_login_note
  before_destroy :create_logout_note
  
  
  private
  def create_login_note
    user.notes.create(:message_type => :new_action, :message => 'LOG IN', :message_value => Time.now.to_i.to_s, 
                      :parent => nil, :noteable_type => 'User', :noteable_id => user.id)
  end
  
  def create_logout_note
    parent_note = Note.find(:last, :conditions => ['user_id = ? and message_type = ? and message = ? and noteable_type = ? and noteable_id = ?', 
                                                    user.id, :new_action, 'LOG IN', 'User', user.id ])
    user.notes.create(:message_type => :end_action, :message => 'LOG OUT', :message_value => Time.now.to_i.to_s, 
                      :parent => parent_note, :noteable_type => 'User', :noteable_id => user.id )
  end
  
end