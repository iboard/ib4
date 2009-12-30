class UsergroupsController < ApplicationController
  filter_resource_access
  
  
  def index
    @usergroups = Usergroup.joinable_groups(current_user)
  end
  
  def show
    @usergroup = Usergroup.find(params[:id])
  end
  
  def new
    @usergroup = Usergroup.new
    @usergroup.user = current_user unless is_admin?
  end
  
  def create
    @usergroup = Usergroup.new(params[:usergroup])
    @usergroup.user = current_user unless is_admin?
    if @usergroup.save
      flash[:notice] = "Successfully created usergroup."
      redirect_to @usergroup
    else
      render :action => 'new'
    end
  end
  
  def edit
    @usergroup = Usergroup.find(params[:id])
  end
  
  def update
    @usergroup = Usergroup.find(params[:id])
    if @usergroup.update_attributes(params[:usergroup])
      flash[:notice] = "Successfully updated usergroup."
      redirect_to @usergroup
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @usergroup = Usergroup.find(params[:id])
    @usergroup.destroy
    flash[:notice] = "Successfully destroyed usergroup."
    redirect_to usergroups_url
  end
end
