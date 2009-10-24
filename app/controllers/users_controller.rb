# File        users_controller.rb
# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# UserController makes use of AuthLogic-Gem
class UsersController < ApplicationController
 
  before_filter :require_user,    :only => [:edit, :update, :destroy, :remove_avatar]
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_admin,   :only => [:index]
  
  def index
    @search = User.search(params[:search])
    @users = @search.paginate( :page => params[:page], :per_page => USERS_PER_PAGE )
  end
  
  def show
    if !params[:id].blank? && params[:id] != 'current'
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @mypostings = @user.postings.descend_by_updated_at.paginate(:page => params[:page], :per_page => POSTINGS_PER_PAGE)
  end

  def new
    @invitation = Invitation.find_by_token(params[:token])
    if @invitation
      @user = User.new(:email => @invitation.recipient_email)
    else
      flash[:error] = t(:no_invitation_token_found)
    end
  end
  
  def create
    params[:user][:password] = Randomizer::randstr(10)
    params[:user][:password_confirmation] = params[:user][:password]
    @user = User.new(params[:user])
    @user.is_admin = params[:user][:is_admin] if is_admin?
    @user.invitations_left = params[:user][:invitations_left] if is_admin?
    if @user.save
      flash[:notice] = t(:registration_successfull)
      UserSession.find.destroy
      @user.send_later(:deliver_new_account_instructions, t(:new_account_instructions_subject))
      if params[:token]
        @invitation = Invitation.find_by_token(params[:token])
        if @invitation
          @invitation.recipient_id = @user.id
          @invitation.save
        end
      end
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    if is_admin? && !params[:id].blank? && params[:id] != 'current'
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end
  
  def update
     if is_admin? && !params[:id].blank?
       @user = User.find(params[:id])
     else
       @user = current_user
     end    
     @user.is_admin = params[:user][:is_admin] if is_admin?
     @user.invitations_left = params[:user][:invitations_left] if is_admin?
     if @user.update_attributes(params[:user])
      flash[:notice] = t(:profile_successfully_updated)
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
  
  def remove_avatar
    if is_admin? && !params[:id].blank?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    
    @user.avatar = nil
    
    if @user.save
      flash[:notice] = t(:avatar_successfully_removed)
      respond_to do |format|
        format.html { redirect_to edit_user_path(@user) }
        format.js
      end
    else
      flash[:error] = t(:error_removing_avatar)
      redirect_to edit_user_path(@user)
    end
  end
  
  def destroy
    if is_admin? && !params[:id].blank?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @user.destroy
    redirect_to :action => :index
  end
end
