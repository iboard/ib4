# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

   # return true if url is part of the actual requested url
   def mark_active_link(item,url)
     if Permalink.is_destination?(url,item[:url]) 
       l=  "<div class='user_menu_selected_url'>#{t(item[:label].to_s.downcase)}</div>"
     else
       l=  "<div class='user_menu_unselected_url'>#{t(item[:label].to_s.downcase)}</div>"
     end
     link_to(l, item[:url])
   end
   
end

   