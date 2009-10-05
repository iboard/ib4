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
end
