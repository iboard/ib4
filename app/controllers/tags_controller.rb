# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# Tag saving is handeld by Tabables itself. The TagsController shows a Tag-Cloud via index and all Tagables of a Tag through show(Tagname)
class TagsController < ApplicationController

  caches_action :index
  

  # Unique tags sorted by name
  def index
    @tagnames = Tag.ascend_by_name.map { |t| t.name }.uniq
  end
  
  # list all tagables of this tag
  def show
    @tagname = params[:id].to_s
    @tags = Tag.name_is(@tagname).descend_by_updated_at.reject {|r| !r.tagable.read_allowed?(current_user) }.paginate(
      :page => params[:page], :per_page => POSTINGS_PER_PAGE)
    @tagables = @tags.map { |t| 
        t.tagable
    }.sort { |b,a| a.updated_at <=> b.updated_at }
  end
end
