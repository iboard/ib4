class NewsletterBlacklistController < ApplicationController
  
  before_filter :require_admin
  
  def index
    @newsletter_blacklists = NewsletterBlacklist.find(:all,:order => "mail asc")
  end

  def destroy
    @newsletter_blacklist = NewsletterBlacklist.find(params[:id])
    @newsletter_blacklist.destroy
    flash[:notice] = "Address removed from blacklist"
    redirect_to :action => "index"
  end

end
