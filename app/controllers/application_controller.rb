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
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  helper_method :current_user
  
  # Redirect to login_path if no current user    
  def require_user
    if !current_user
      redirect_to login_path
    end
  end
  
  # Logout if logged_in
  def require_no_user
    redirect_to logout_path if current_user
  end
  
  # Redirect to login path if current_user is not admin
  def require_admin_and_root
    if !current_user || !current_user.is_admin? || current_user.username != 'root'
      flash[:error] = t(:admin_root)
      redirect_to login_path
    end
  end

  # Redirect to login path if current_user is not admin
  def require_admin
    if !current_user || !current_user.is_admin?
      flash[:error] = t(:admin_required)
      redirect_to login_path
    end
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
    
end

# End of File:    application_controller.rb