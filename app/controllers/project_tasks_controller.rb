class ProjectTasksController < ApplicationController
  
  before_filter :load_project
  filter_resource_access
  
  def index
    @project_tasks ||= @project.project_task.all
  end
  
  def show
    @project_task = @project.project_tasks.find(params[:id])
  end
  
  def new
    @project_task = @project.project_taks.build
  end
  
  def create
    @project_task = @project.project_tasks.build(params[:project_task])
    if @project_task.save
      flash[:notice] = "Successfully created projecttask."
      @project.notes.create( :user_id => current_user, :message => @project_task.name, :message_type => 'created_task')
    end
  end
  
  def edit
    @project_task = @project.project_tasks.find(params[:id])
  end
  
  def update
    @project_task = @project.project_tasks.find(params[:id])
    if @project_task.update_attributes(params[:project_task])
      flash[:notice] = "Successfully updated projecttask."
      @project.notes.create( :user_id => current_user, :message => @project_task.name, :message_type => 'updated_task')
    end
  end
  
  def destroy
    @project_task = ProjectTask.find(params[:id])
    @project_task.destroy
    flash[:notice] = "Successfully destroyed projecttask."
    redirect_to @project
  end
  
  private
  def load_project
    @project ||= Project.find(params[:project_id])
  end
end
