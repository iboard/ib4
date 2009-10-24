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
  
  before_filter :set_language
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  helper_method :current_user,:is_admin?,:is_user?,:is_owner?,:is_owner_or_admin?,:is_current_user?
  
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
  
  
  private
  
  # Get/set the cached current session
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  # Get/set the cached current user
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
    
  private
  def set_language
    I18n.locale = session['locale'] || DEFAULT_LOCALE
  end
end

# End of File:    application_controller.rb