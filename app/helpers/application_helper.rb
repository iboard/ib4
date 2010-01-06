# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # I18n support for willpaginate
  include WillPaginate::ViewHelpers   
  def will_paginate_with_i18n(collection, options = {})
    will_paginate_without_i18n(collection, options.merge(:prev_label => I18n.t(:previous_label), :next_label => I18n.t(:next_label)))
  end
  alias_method_chain :will_paginate, :i18n
  
   # return true if url is part of the actual requested url
   def mark_active_link(item,url)
     l = link_to((item[:label]), item[:url])
     if Permalink.is_destination?(url,item[:url]) 
       "<div class='user_menu_selected_url'>"+l+ "</div>"
     else
       "<div class='user_menu_unselected_url'>"+l+ "</div>"
     end
   end
   
   def public_menu
      #items = Array.new
      #Page.roots.each do |p|
      #  items << {:label => p.title, :url => page_path(p)}
      #end

      #translate items defined in environment USER_MENU_ITEMS
      items = USER_MENU_ITEMS.map { |i|
         { :label => t(i[:label].to_sym), :url => i[:url] }
      }

      # output the menu
      items.map { |item|
            mark_active_link(item,request.request_uri)
      }.join("")
   end
   
   # Progress bar "<div id='ajax_msg'>" + t(:working) + "</div>" + BR*2 + 
   def show_spinner
     content_tag( "div",image_tag("spinner.gif", :align=>:middle),
      :id => "ajax_busy", :style => "display:none;" )
   end
   
   def start_update
      periodically_call_remote(:url => {:controller => 'user_sessions', :action => 'get_ajax_msg'}, :frequency => '1', 
          :update => 'ajax_msg');
   end
   
   def humanize_time_span(t2,t1=nil)
     t1 ||= Time.now
     d = t2 - t1
     a = d.abs
     p = :minutes
     p = :hours if a > 1.hour
     p = :days  if a > 1.day
     p = :weeks if a > 1.week
     p = :months if a> 1.month
     p = :years if a > 1.year
     
     case p
     when :minutes
       r = t( ( d.to_i > 0 ? :in_minutes : :minutes_ago), :count => (a/1.minute).round )
     when :hours
       r = t( ( d.to_i > 0 ? :in_hours : :hours_ago), :count => (a/1.hour).round )
     when :days
       r = t( ( d.to_i > 0 ? :in_days : :days_ago), :count => (a/1.day).round )
     when :weeks
       r = t( ( d.to_i > 0 ? :in_weeks : :weeks_ago), :count => (a/1.week).round )
     when :months
       r = t( ( d.to_i > 0 ? :in_months : :months_ago), :count => (a/1.month).round )
     when :years
       r = t( ( d.to_i > 0 ? :in_years : :years_ago), :count => (a/1.year).round )
     end
     "<span title='#{t2.to_s(:short)}' style='cursor:help;'>#{r}</span>"
   end

   
end
