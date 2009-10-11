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
   
end

   
