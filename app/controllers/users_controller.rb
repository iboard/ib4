# File        users_controller.rb
# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# UserController makes use of AuthLogic-Gem
class UsersController < ApplicationController
 
  filter_resource_access
 
  before_filter :require_user,    :except => [:new,:create]
  before_filter :require_no_user, :only => [:new, :create]
  
  def index
    @search = User.search(params[:search])
    @users = @search.paginate( :page => params[:page], :per_page => USERS_PER_PAGE )
  end
  
  def show
    @mypostings = @user.postings.descend_by_updated_at.paginate(:page => params[:page], :per_page => POSTINGS_PER_PAGE)
  end

  def new
    @invitation = Invitation.find_by_token(params[:token])
    if @invitation
      @user = User.new(:email => @invitation.recipient_email)
    else
      flash[:error] = t(:no_invitation_token_found)
      @user = nil
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
  end
  
  def update
     @user.is_admin = params[:user][:is_admin] if is_admin? && params[:user][:is_admin]
     @user.invitations_left = params[:user][:invitations_left] if is_admin?  && params[:user][:invitations_left]
     if @user.update_attributes(params[:user])
      flash[:notice] = t(:profile_successfully_updated)
      if params[:user][:task_actions_attributes]
        redirect_to user_task_actions_path(@user)
      else
        redirect_to root_url
      end
     else
       render :action => 'edit'
     end
  end
  
  def remove_avatar
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
    @user.destroy
    redirect_to :action => :index
  end
  
  def join_group
    @user = User.find(params[:id])
    @group= Usergroup.find(params[:usergroup_id])
    ms = @user.group_memberships.create(:usergroup_id => params[:usergroup_id]) if @user && @group
  end
  
  def leave_group
    @user = User.find(params[:id])
    @group= Usergroup.find(params[:usergroup_id])
    ms = @user.group_memberships.find_by_usergroup_id(params[:usergroup_id]) if @user && @group
    ms.destroy if ms
  end

  def sort_task_actions
    logger.info("\n*** SORT TASK ACTIONS #{params.inspect}\n")
    params[:task_list].each_with_index do |t,i|
      task = TaskAction.find(t)
      task.position=i
      task.save
    end
    render :nothing => true
  end  
end
