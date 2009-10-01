# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # search will be splitted by whitespace or colons and then text found for each part in txt will be highlighted by span color green...
  def highlight_search(search,txt)
    return txt if search.blank?
    search.split(/[\s|,]+/).each do |s|
       txt.gsub!("#{s}","<span style=\"color: #080; font-weight: bold;\">#{s}</span>")      
    end
    txt
  end
  
  def box_float_right(width="25%",css_class='box_float_right')
    concat("<div class='#{css_class}' style='width: #{width}px;'>")
    yield
    concat("</div>")
  end
  
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

   