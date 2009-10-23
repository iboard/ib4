class FeedController < ApplicationController

  def index
    items    = Page.find(:all) + Posting.find(:all) + Comment.find(:all)
    @items   = items.sort { |b,a| a.updated_at <=> b.updated_at }[0..MAX_FEED_ITEMS]
  end
  
  def show
    redirect_to :action => 'index'
  end

end
