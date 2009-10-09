# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# Some helpers for the layout
module LayoutHelper
  
  # sets the page_tile which is used in application.html.erb
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end
  
  # Do not output <h1></h1> in no title is set when rendering
  def show_title?
    @show_title
  end
  
  # Append a stylesheet to the :head for yield in application.html.erb
  def stylesheet(*args)
    content_for(:html_head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end
  
  # Append a javascript to the html-head
  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:html_head) { javascript_include_tag(*args) }
  end
  
  # Append a rss-link to the html-head
  def rss_link(*args)
    content_for(:html_head) { auto_discovery_link_tag(*args.map(&:to_s)) }
  end
  
  # search will be splitted by whitespace or colons and then text found for each part in txt will be highlighted by span color green...
  def highlight_search(search,txt)
    return txt if search.blank?
    search.split(/[\s|,]+/).each do |s|
       txt.gsub!("#{s}","<span style=\"color: #080; font-weight: bold;\">#{s}</span>")      
    end
    txt
  end
  
  # use this instead of <hr>
  def divider
    "<div class='divider'></div>"
  end
    
  # insert a right floating box  
  def box_float_right(width=RIGHT_BOX_DEFAULT_WIDTH,css_class='box_float_right')
    concat("<div class='#{css_class}' style='width: #{width}'>")
    yield
    concat("</div>")
  end
  
  # Display the lable as a link which toggles display of the given block
  def toggle_display_link(label='show more')
  
     ids = "details_#{rand(999999).round.to_s}"
     
     concat( 
       "<div id='can_open_#{ids}'>
          <a href='##{ids}' 
          onclick=\"Element.blindDown(\'#{ids}\');Element.hide(\'can_open_#{ids}\'); Element.show(\'can_close_#{ids}\');return false;\">#{CAN_OPEN}&nbsp;#{label}</a>" +
        "</div>" +
        "<div id='can_close_#{ids}'  style='display: none;' >
          <a href='##{ids}' 
          onclick=\"Element.blindUp(\'#{ids}\');  Element.hide(\'can_close_#{ids}\');Element.show(\'can_open_#{ids}\');return false;\">#{IS_OPEN}&nbsp;#{label}</a>" +
        "</div>"+
        "<div id='#{ids}' style='display:none;'>"
     )
     
     yield
     
     concat( 
       "<div id='close_up#{ids}'>
         <a href='##{ids}' 
         onclick=\"Element.blindUp(\'#{ids}\');  Element.hide(\'can_close_#{ids}\');Element.show(\'can_open_#{ids}\');return false;\">#{CLOSE_UP}&nbsp;#{label}</a>" +
       "</div>"+
       "</div>"
     )
  end  
  
end
