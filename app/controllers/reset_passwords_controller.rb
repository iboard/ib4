# File        reset_passwords_controller.rb
# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
#
# There is no model for this controller.
# When a user wants to reset ones password a mail will be delivered after reseting the perishable_token
# of AuthLogic
class ResetPasswordsController < ApplicationController
  
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]  
  before_filter :require_no_user  
    
  def new
  end
  
  def edit  
  end
  
  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!(t(:reset_password_instructions_subject))
      flash[:notice] = t(:password_reset_instructions)
      redirect_to root_url
    else
      flash[:error] = t(:user_not_found_for_password_reset)
      render :action => :new
    end
  end
  
  def update  
    @user.password              = params[:user][:password]  
    @user.password_confirmation = params[:user][:password_confirmation]  
    if  !@user.password.blank? && @user.save
      flash[:notice] = t(:password_successfully_updated)  
      redirect_to root_url  
    else
      flash[:error] = t(:please_enter_your_new_password)
      render :action => :edit  
    end  
  end  
  
  
  private  
  
  def load_user_using_perishable_token  
    @user = User.find_using_perishable_token(params[:id])  
    unless @user  
      flash[:notice] = "We're sorry, but we could not locate your account. " +  
      "If you are having issues try copying and pasting the URL " +  
      "from your email into your browser or restarting the " +  
      "reset password process."  
      redirect_to root_url  
    end
  end
  
end
