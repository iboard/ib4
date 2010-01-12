# File        application_controller.rb
# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# Handels current_user and current_session purposes
#
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  include ExceptionNotifiable
  
  before_filter :set_language
  before_filter :initialize_settings
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  helper_method :current_user,:is_admin?,:is_user?,:is_owner?,:is_owner_or_admin?,
                :is_current_user?,:clear_tags_cache,:clear_category_cache

  before_filter { |c| 
    Authorization.current_user = c.current_user 
  }
  
  before_filter :clear_message_cache
  
  # Redirect to login_path if no current user    
  def require_user
    unless current_user
      redirect_to login_path
    end
  end
  
  # Logout if logged_in
  def require_no_user
    redirect_to logout_path if current_user
  end
  
  # Redirect to login path if current_user is not admin
  def require_admin_and_root
    unless is_admin? && current_user.username.eql?('root')
      flash[:error] = t(:admin_root)
      redirect_to login_path
    end
  end

  # Redirect to login path if current_user is not admin
  def require_admin
    unless is_admin?
      flash[:error] = t(:admin_required)
      redirect_to login_path
    end
  end
  
  def is_admin?
    current_user && current_user.is_admin?
  end
  
  def is_user?
    current_user != nil
  end
 
  def is_owner?(item)
    is_user? && item.user == current_user 
  end
  
  def is_owner_or_admin?(item)
    (is_admin? || ( is_user? && item.user == current_user))
  end 
  
  def is_current_user?(user)
    current_user && current_user == user
  end
   
  def clear_tags_cache
    expire_action :controller => :tags, :action => :index
    expire_fragment :tags_index
  end
  
  def clear_category_cache
    expire_action :controller => :categories, :action => :index
    expire_fragment :categories_index_postings
    expire_fragment :categories_index_pages
  end
  
  # Get/set the cached current user
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
    
  def search  
    if !params[:search_txt] || params[:search_txt].empty?
        flash[:error] = t(:please_enter_a_searchterm)
        redirect_to root_path
        return false
    end
    pages = Page.title_like_any_or_description_like_any_or_body_like_any(
                  params[:search_txt].split(/[\s|,]+/)
             ).descend_by_updated_at.all
    postings = Posting.subject_like_any_or_body_like_any(
               params[:search_txt].split(/[\s|,]+/)
              ).descend_by_updated_at.all
    comments =  Comment.comment_like_any(params[:search_txt].split(/[\s|,]+/)).all
    
    commentables =  comments.map { |c| c.commentable }
    
    @items = [pages,postings,comments].flatten.reject { |x| x.nil? }.sort { |b,a| a.updated_at <=> b.updated_at }
    unless @items.any?
      flash[:error] = t(:nothing_found)
      redirect_to root_path
    end
  end
  
  protected
  def permission_denied
    if params[:controller] == 'binaries'
      send_file( RAILS_ROOT + "/public" + FILE_LOCKED_PATH, :type => 'image/png', 
                 :disposition => (params[:download] ? 'attachment' : 'inline' ), 
                 :filename => File::basename(FILE_LOCKED_PATH) )
    else
      flash[:error] = t(:access_denied)
      redirect_to login_path
    end
  end
  
  private
  # Get/set the cached current session
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def server_root_path
    return @server_root_path if @server_root_path
    @server_root_path = request.request_uri.gsub(/\/\/(.*)\/(.*)/, '//$1/')
  end
    
  def set_language
    I18n.locale = session['locale'] || DEFAULT_LOCALE
  end
  
  def initialize_settings
    session[:stickies] ||= {}
  end

  def clear_message_cache
      if session && session['message_cache_time'] && (Time.now()-session['message_cache_time']) > MESSAGE_CHACHE_MINUTES 
        expire_fragment( "messages_#{current_user.id.to_s}" ) if current_user
      end
  end
end

# End of File:    application_controller.rb