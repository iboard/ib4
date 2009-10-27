class Newsletter < ActiveRecord::Base
  
  validates_presence_of :title, :reply_to
  
  has_attached_file :banner, 
                    :styles => { 
                      :default => "800x100>", :preview => "100x100>"
                    }, 
                    :whiny_thumbnails => true

  has_many :newsletter_subscriptions, :dependent => :destroy
  has_many :newsletter_issues, :dependent => :destroy
  has_many :newsletter_deliveries, :through => :newsletter_issues
  
  
  def render_header(subscripton_url,newletter_mail,block_mail_url)
    header.gsub(/SUBSCRIPTION_URL/, subscripton_url).gsub(/NEWSLETTER_MAIL/,newletter_mail).gsub(/BLOCK_MAIL_URL/,block_mail_url)
  end
  
  def render_footer(subscripton_url,newletter_mail,block_mail_url)
    footer.gsub(/SUBSCRIPTION_URL/, subscripton_url).gsub(/NEWSLETTER_MAIL/,newletter_mail).gsub(/BLOCK_MAIL_URL/,block_mail_url)
  end
    
end
