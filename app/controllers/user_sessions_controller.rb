class UserSessionsController < ApplicationController

  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = t(:successfully_logged_in, 
        :username => current_user.username, 
        :last_login_at => current_user.last_login_at.to_s(:short),
        :last_login_ip => current_user.last_login_ip,
        :login_count => current_user.login_count,
        :failed_login_count => current_user.failed_login_count
        )
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = t(:successfully_logged_out)
    redirect_to root_url
  end
end
