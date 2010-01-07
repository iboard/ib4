module PermalinksHelper
  
  def display_permalinks(for_object,controller)
    if for_object.permalinks.any?
        s = "<div class='permalinks'>"
        s1 = ""
        for_object.permalinks.each { |pl| 
          s1 += render_permalink(pl,controller).to_s
        }
        s += toggle_display_link( t(:permalinks) ) {
          s1
        }.to_s
        s += "</div>"
    end
  end
  
  def render_permalink(permalink,controller)
    content_tag( :span, :style => 'font-size: 10px;') do
      rc = NBSP*2+link_to(
       (request.ssl? ? "https://" : "http://")+
       request.server_name + 
       "/" +  permalink.url, 
       "/"+permalink.url 
      )
      
      if controller.request[:action] == 'edit' && is_owner_or_admin?(permalink.linkable) 
          rc += hidden_field_tag( "#{permalink.linkable.class.to_s.downcase}[permalink_ids][]", permalink.id ) +
          link_to( NBSP*3+BACKSPACE_CHAR,permalink, 
            :method => 'delete', 
            :confirm => I18n.translate(:are_you_sure, :what => I18n.translate(:delete_a_permalink)), 
            :title => t(:delete) 
          )
       end
       rc + BR
     end
   end
  
end
