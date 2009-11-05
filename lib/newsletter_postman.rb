class NewsletterPostman < Struct.new(:newsletter_issue_id, :title, :subject, :header_image_tag, :header, :footer, :body, :url )
  def perform
    @issue = NewsletterIssue.find(newsletter_issue_id)
    @issue.newsletter.newsletter_subscriptions.each do |subscription|
      if NewsletterBlacklist.find_by_mail(subscription.mail).nil?  && @issue.newsletter_deliveries.find(:all,
                   :include => :newsletter_subscription, 
                   :conditions => ['newsletter_subscriptions.mail = ?',subscription.mail]
        ).empty? 
        # only if address not blacklisted and no delivery for this issue and mail pair exists
        begin
          UserMailer.deliver_newsletter(
            @issue.newsletter.reply_to, 
            subscription.mail, 
            title, 
            subject, 
            header_image_tag, 
            header.gsub(/SUBSCRIPTION_URL/, 
                     "<a href='#{ROOT_URL}/subscriptions/#{encode64(subscription.mail)}/#{subscription.token}'>Your Subscriptions</a>"
                   ).gsub(/NEWLETTER_MAIL/, subscription.mail
                   ).gsub(/BLOCK_MAIL_URL/, 
                     "<a href='#{ROOT_URL}/subscriptions/#{encode64(subscription.mail)}/#{subscription.token}'>Your Subscriptions</a>"
                   ), 
                    
            footer.gsub(/SUBSCRIPTION_URL/, 
                     "<a href='#{ROOT_URL}/subscriptions/#{encode64(subscription.mail)}/#{subscription.token}'>Your Subscriptions</a>"
                   ).gsub(/NEWLETTER_MAIL/, subscription.mail
                   ).gsub(/BLOCK_MAIL_URL/, 
                     "<a href='#{ROOT_URL}/subscriptions/#{encode64(subscription.mail)}/#{subscription.token}'>Your Subscriptions</a>"
                   ), 
            body, 
            url
          )
          d = @issue.newsletter_deliveries.create(:newsletter_subscription_id => subscription.id, :delivered_at => Time::now() )
          d.save!
          sleep(3) # give other smpt-tasks a chance to deliver their mails ;-)
        rescue => e
          d = @issue.newsletter_deliveries.create(:newsletter_subscription_id => subscription.id, :delivered_at => Time::now(),
                :failure_messages => e.to_s )
          d.save!
        end
      else
        if (bl = NewsletterBlacklist.find_by_mail(subscription.mail))
          subscription.destroy
        end
      end
    end
  end
end