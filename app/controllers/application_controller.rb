# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  helper_method :current_user
      
  def require_user
    if !current_user
      redirect_to login_path
    end
  end
  
  def require_no_user
    redirect_to logout_path if current_user
  end
  
  def require_admin
    if !current_user || current_user.username != 'root'
      flash[:error] = t(:admin_required)
      redirect_to login_path
    end
  end
  
  private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
    
end
