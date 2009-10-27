class NewsletterSubscription < ActiveRecord::Base
  belongs_to              :newsletter
  validates_presence_of   :mail
  validates_uniqueness_of :mail, :scope => :newsletter_id
  
  before_save :generate_token
  
  
  private
  def generate_token
    self.token ||= Randomizer::randstr(16)
  end
end
