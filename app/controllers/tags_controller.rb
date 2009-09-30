class TagsController < ApplicationController

  # Unique tags sorted by name
  def index
    @tagnames = Tag.ascend_by_name.map { |t| t.name }.uniq
  end
  
  # list all tagables of this tag
  def show
    @tagname = params[:id].to_s
    @tags = Tag.name_is(@tagname)
    @tagables = @tags.map {|t| t.tagable }.sort { |b,a| a.updated_at <=> b.updated_at }
  end
end
