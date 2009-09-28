class UsersController < ApplicationController
 
  before_filter :require_user,    :only => [:show, :edit, :update,:destroy]
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_admin,   :only => [:index]
  
  def index
    @search = User.search(params[:search])
    @users = @search.paginate( :page => params[:page], :per_page => 1 )
  end
  
  def show
    if current_user.is_admin? && !params[:id].blank? && params[:id] != 'current'
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def new
    @user = User.new
  end
  
  def create
    params[:user][:password] = Randomizer::randstr(10)
    params[:user][:password_confirmation] = params[:user][:password]
    @user = User.new(params[:user])

    if @user.save
      flash[:notice] = t(:registration_successfull)
      UserSession.find.destroy
      @user.deliver_new_account_instructions!(t(:new_account_instructions_subject))
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    if current_user.is_admin? && !params[:id].blank? && params[:id] != 'current'
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end
  
  def update
     if current_user.is_admin? && !params[:id].blank?
       @user = User.find(params[:id])
     else
       @user = current_user
     end    
     if @user.update_attributes(params[:user])
      flash[:notice] = t(:profile_successfully_updated)
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    if current_user.is_admin? && !params[:id].blank?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @user.destroy
    redirect_to :action => :index
  end
end
