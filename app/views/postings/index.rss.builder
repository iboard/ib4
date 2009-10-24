xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title t(:postings_at_host, :host => LOCALHOST_NAME)
    xml.description t(:postings_feed_description)
    xml.link postings_url
    
    for posting in @postings
      xml.item do
        xml.title posting.subject
        xml.description(
          image_tag(
            posting.user.avatar.url(:icon), 
            :align=>:left,:hspace => 5,:vspace => 5,
            :title => posting.user.fullname+NBSP+"(#{h(posting.user.username)})"
          ) + 
          "<p><strong><em>" +
              t(:comment_days_ago, :fullname => h(posting.user.fullname),
                           :username=>h(posting.user.username), 
                           :count => ((Time.now-posting.updated_at)/1.day).round.to_i 
              ) +
          "</em></strong></p>" +
          posting.body.to_txt + BR + COMMENT_HAND + NBSP +
          t(:count_comments, :count => posting.comments.size) + BR
        )
        xml.pubDate posting.updated_at.to_s(:rfc822)
        xml.link posting_url(posting)
      end
    end
  end
end