# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

   # return true if url is part of the actual requested url
   
   def is_active_url?(url)
     if @page && @page.permalinks.any?
       @page.permalinks.detect{|u| u.permalinkable.url == url }
     else
       request.request_uri.eql?(url)
     end
   end
   
   
end

   