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
  
end
