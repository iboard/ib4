class NewsletterBlacklist < ActiveRecord::Base
  validates_uniqueness_of :mail
end
