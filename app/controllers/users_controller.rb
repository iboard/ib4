class UsersController < ApplicationController
 
  def index
  end

  def new
    @user = User.new
  end
  
  def create
    @user = current_user
    if @user.save
      flash[:notice] = "Registration successfull."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = t(:profile_successfully_updated)
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
end
