class ProjectsController < ApplicationController

  filter_resource_access :attribute_check => true, :load_method  => lambda {
    @project =   Project.find(params[:id],:include => [:page,:project_tasks]) if params[:id]
  }
  
  def index
    @projects = Project.find(:all, :order => 'name asc', 
      :include => [:page]).reject {|r| !permitted_to?(:show,r)}
  end
  
  def show
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

  def sort_tasks
    @project ||= Project.find(params[:id])
    params[params[:list_id]].each_with_index do |id,index|
      task = @project.project_tasks.find(id)
      task.position = index+1
      task.save
    end
    render :nothing => true
  end 
   
  def update_tasklist
    @project ||= Project.find(params[:id])
    @use_filter = params[:filter]
  end
  
end
