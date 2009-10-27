class NewsletterDelivery < ActiveRecord::Base
  belongs_to :newsletter_issue
  belongs_to :newsletter_subscription
end
