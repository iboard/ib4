# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
   # return true if url is part of the actual requested url
   def mark_active_link(item,url)
     l = link_to(t(item[:label].to_s.downcase), item[:url])
     if Permalink.is_destination?(url,item[:url]) 
       "<div class='user_menu_selected_url'>"+l+ "</div>"
     else
       "<div class='user_menu_unselected_url'>"+l+ "</div>"
     end
   end
   
   
   # I18n support for willpaginate
   include WillPaginate::ViewHelpers   
   def will_paginate_with_i18n(collection, options = {})
     will_paginate_without_i18n(collection, options.merge(:prev_label => I18n.t(:previous_label), :next_label => I18n.t(:next_label)))
   end
   alias_method_chain :will_paginate, :i18n


   # Progress bar "<div id='ajax_msg'>" + t(:working) + "</div>" + BR*2 + 
   def show_spinner
     content_tag( "div",image_tag("spinner.gif", :align=>:middle),
      :id => "ajax_busy", :style => "display:none;" )
   end
   
   def start_update
      periodically_call_remote(:url => {:controller => 'user_sessions', :action => 'get_ajax_msg'}, :frequency => '1', 
          :update => 'ajax_msg');
   end
   
      
end
