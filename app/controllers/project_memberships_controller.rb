class ProjectMembershipsController < ApplicationController
  def index
    @project_memberships = ProjectMembership.all
  end
  
  def show
    @project_membership = ProjectMembership.find(params[:id])
  end
  
  def new
    @project_membership = ProjectMembership.new
  end
  
  def create
    @project_membership = ProjectMembership.new(params[:project_membership])
    if @project_membership.save
      flash[:notice] = "Successfully created projectmembership."
      redirect_to @project_membership
    else
      render :action => 'new'
    end
  end
  
  def edit
    @project_membership = ProjectMembership.find(params[:id])
  end
  
  def update
    @project_membership = ProjectMembership.find(params[:id])
    if @project_membership.update_attributes(params[:project_membership])
      flash[:notice] = "Successfully updated projectmembership."
      redirect_to @project_membership
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @project_membership = ProjectMembership.find(params[:id])
    @project_membership.destroy
    flash[:notice] = "Successfully destroyed projectmembership."
    redirect_to project_memberships_url
  end
end
