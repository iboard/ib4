class NewsletterTestmailer < Struct.new(:newsletter_issue_id, :title, :subject, :header_image_tag, :header, :footer, :body, :url )
  def perform
    @issue = NewsletterIssue.find(newsletter_issue_id)      
    UserMailer.deliver_newsletter(
      @issue.newsletter.reply_to, 
      @issue.newsletter.reply_to, 
      title, 
      subject, 
      header_image_tag, 
      header.gsub(/SUBSCRIPTON_URL/, 
               "<a href='#{ROOT_URL}/subscriptions/#{encode64(@issue.newsletter.reply_to)}/TOKEN'>Your Subscriptions</a>"
             ).gsub(/NEWLETTER_MAIL/, @issue.newsletter.reply_to
             ).gsub(/BLOCK_MAIL_URL/, 
               "<a href='#{ROOT_URL}/subscriptions/#{encode64(@issue.newsletter.reply_to)}/TOKEN'>Your Subscriptions</a>"
             ), 
              
      footer.gsub(/SUBSCRIPTON_URL/, 
               "<a href='#{ROOT_URL}/subscriptions/#{encode64(@issue.newsletter.reply_to)}/TOKEN'>Your Subscriptions</a>"
             ).gsub(/NEWLETTER_MAIL/, @issue.newsletter.reply_to
             ).gsub(/BLOCK_MAIL_URL/, 
               "<a href='#{ROOT_URL}/subscriptions/#{encode64(@issue.newsletter.reply_to)}/TOKEN'>Your Subscriptions</a>"
             ), 
      body, 
      url
    )    
  end
end