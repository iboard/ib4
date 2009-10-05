xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title t(:postings_at_host, :host => LOCALHOST_NAME)
    xml.description t(:postings_feed_description)
    xml.link formatted_postings_url(:html)
    
    for posting in @postings
      xml.item do
        xml.title posting.subject
        xml.description(
          image_tag(
            posting.user.avatar.url(:icon), 
            :align=>:left,:hspace => 5,:vspace => 5,
            :title => posting.user.fullname+NBSP+"(#{posting.user.username})"
          ) + 
          "<p><strong><em>#{posting.user.fullname}, at " +
              t(:days_ago, :count => ((Time.now-posting.updated_at)/1.day).round.to_i ) +
          "</em></strong></p>" +
          textilize(h(posting.body))
        )
        xml.pubDate posting.updated_at.to_s(:rfc822)
        xml.link formatted_posting_url(posting,:html)
      end
    end
  end
end