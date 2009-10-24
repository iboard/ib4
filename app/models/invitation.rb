class Invitation < ActiveRecord::Base
  belongs_to :sender,    :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
  
  validates_presence_of :recipient_email
  validates_uniqueness_of :recipient_email
  validate :recipient_email_format
  
  before_create :set_token
  
  private
  def recipient_email_format
    unless recipient_email =~ Authlogic::Regex::email
      errors.add :recipient_email, t(:email_format_not_valid)
      false
    end
    true
  end
  
  def set_token
    self.token = Randomizer::randstr(12)
  end
end
