class ProjectsController < ApplicationController

  filter_resource_access
  
  def index
    @projects ||= Project.ascend_by_name.reject {|r| !permitted_to?(:show,r)}
  end
  
  def show
    @project ||= Project.find(params[:id])
  end
  
  def new
    @project ||= current_user.projects.build(Project.new)
  end
  
  def create
    params[:project][:user_id] = (is_admin? && params[:project][:user_id]) ? params[:project][:user_id] : current_user
    @project = Project.new(params[:project])
    if @project.save
      flash[:notice] = "Successfully created project."
      redirect_to @project
    else
      render :action => 'new'
    end
  end
  
  def edit
    @project ||= Project.find(params[:id])
  end
  
  def update
    @project ||= Project.find(params[:id])
    if @project.update_attributes(params[:project])
      flash[:notice] = "Successfully updated project."
      redirect_to @project
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @project ||= Project.find(params[:id])
    @project.destroy
    flash[:notice] = "Successfully destroyed project."
    redirect_to projects_url
  end
  
end
