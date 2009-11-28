# File        user_sessions_controller.rb
# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
#
# There is one session at a time for one user.
# create means login where destroy means log out.
class UserSessionsController < ApplicationController

  
  def new
    @user_session = UserSession.new
  end
  
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      cu = Authorization.current_user
      if cu.class == User  
        flash[:notice] = t(:successfully_logged_in,:username => cu.username)
        flash[:notice] += "<br/>" +t(:failed_login_count_notice, :count => cu.failed_login_count) if cu.failed_login_count > 0
        flash[:notice] += "<br/>" +
           t(:last_login_at_notice, 
             :last_login_at => cu.last_login_at.to_s(:short), 
             :last_login_ip => cu.last_login_ip) unless cu.last_login_at.nil?
      else
        flash[:notice] = t(:logged_in)
      end
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
  
  
  def sleep_a_while
    n = rand(5).round+1
    sleep n
    render :update do |page|
      msg = t(:done)
      page.replace_html :flash, content_tag(:div, msg, :id => 'flash_notice')
    end
  end
  
  def set_locale
    session['locale'] = params[:locale]
    changed = session['locale'] != current_locale
    I18n.locale = session['locale']
    respond_to do |format|
      format.html { redirect_to request.env['HTTP_REFERER'] }
      format.js
    end
  end

  def current_locale
    session['locale'] || DEFAULT_LOCALE
  end
  
  def set_sticky
    session[:stickies][params[:id].to_sym] = true
    render :nothing => true
  end
  
  def set_unsticky
    session[:stickies][params[:id].to_sym] = false
    render :nothing => true  
  end
 
end
