class UserSession < Authlogic::Session::Base
  after_create   :create_login_note
  before_destroy :create_logout_note
  
  attr_reader :last_login
  
  private
  def create_login_note
    if last_login && last_login.children.empty?
      logger.info("*** AUTOCLOSE SESSION #{self.inspect}")
      last_login.children.create(:message_type => :end_action, 
                                 :message => 'LOG OUT (autom. session reset at login)', 
                                 :message_value => Time.now.to_i.to_s, 
                                 :parent => last_login, 
                                 :noteable_type => 'User', :noteable_id => user.id)
    else
      user.notes.create(:message_type => :new_action, :message => 'LOG IN', :message_value => Time.now.to_i.to_s, 
                      :user_id => user.id, :noteable_type => 'User', :noteable_id => user.id)
      @last_login = nil
    end
  end
  
  def create_logout_note
    if !last_login
      user.notes.create(:message_type => :new_action, :message => 'LOG IN (autom. session login at logout)', 
                        :message_value => Time.now.to_i.to_s, 
                        :user_id => user.id, :noteable_type => 'User', :noteable_id => user.id)
    end
    user.notes.create(:message_type => :end_action, :message => 'LOG OUT', :message_value => Time.now.to_i.to_s, 
                      :parent => last_login, :noteable_type => 'User', :noteable_id => user.id )
  end
  
  def last_login
    @last_login ||= Note.find(:last, 
                       :conditions => ['user_id = ? and message_type = ? and message = ? and noteable_type = ? and noteable_id = ?', 
                       user.id, :new_action, 'LOG IN', 'User', user.id ])
  end
  
end