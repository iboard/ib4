class NewsletterIssue < ActiveRecord::Base
  
  belongs_to :newsletter
  validates_presence_of :subject, :body
  has_many :newsletter_deliveries, :dependent => :destroy
  
  def print_state_column
    msg = ""

    if self.queued_at
      msg += "Queued at: #{queued_at.to_s(:short)}<br/>"
    else
      msg += "Not queued yet<br/>" 
    end

    cnt_100 = self.newsletter.newsletter_subscriptions.count
    if cnt_100 == 0
      msg += "No subscriptions"
    else
      cnt_q   = NewsletterDelivery.find(:all,:order => 'delivered_at desc', :conditions => ['newsletter_issue_id = ?', self.id]).length+0.0
      cnt_per = (cnt_q/cnt_100)*100.0
      cnt_p   = cnt_per > 100.0 ? 100 : cnt_per.round
      msg += "<img src='/images/bar_green.gif' width='#{2*cnt_p}' alt='Sent...' height='10'><img
                   src='/images/bar_empty.gif' width='#{200-(2*cnt_p)}' alt='Queued...' height='10'><br/>
              #{cnt_q.round} of #{cnt_100} (#{cnt_p}%) mails queued."
    end
    msg
  end
  
end
