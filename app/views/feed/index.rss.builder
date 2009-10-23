xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title t(:site_feed_title, :host => LOCALHOST_NAME)
    xml.description t(:site_feed_description)
    xml.link feed_url(0)
    
    for item in @items
      if item.respond_to? :list_title
        xml.item do
          xml.title item.class.to_s + ": " + item.list_title(128)
          descr = item.rss_body.to_txt
          if item.user
            descr = image_tag(
                item.user.avatar.url(:icon), 
                :align=>:left,:hspace => 5,:vspace => 5,
                :title => item.user.fullname+NBSP+"(#{h(item.user.username)})"
              ) + 
              "<p><strong><em>" +
                  t(:comment_days_ago, :fullname => h(item.user.fullname),
                               :username=>h(item.user.username), 
                               :count => ((Time.now-item.updated_at)/1.day).round.to_i 
                   ) +
              "</em></strong></p>" +
              item.rss_body.to_txt
          else 
            descr = item.rss_body.to_txt
          end
          descr += BR+COMMENT_HAND+NBSP+t(:count_comments, :count => item.comments.size) if item.respond_to? 'comments'
          xml.description(descr)
          xml.pubDate item.updated_at.to_s(:rfc822)
          eval "@url=#{item.class.to_s.downcase}_url(item)"
          xml.link @url
        end
      end
    end
  end
end