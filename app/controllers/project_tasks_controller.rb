class ProjectTasksController < ApplicationController
  
  before_filter :load_project
  filter_resource_access
  
  def index
    params[:search] ||= {  }
    params[:search][:project_id] = @project.id
    @search =ProjectTask.search(params[:search])
    @project_tasks ||= @search.all(:include => [:children,:project])
  end
  
  def show
    @project_task = @project.project_tasks.find(params[:id],:include => [:children,:project])
    respond_to do |format|
      format.html { redirect_to project_project_tasks_path(@project)}
      format.js
    end
  end
  
  def new
    @project_task = @project.project_tasks.build
  end
  
  def create
    @project_task = @project.project_tasks.build(params[:project_task])
    if @project_task.save
      flash[:notice] = "Successfully created projecttask."
      @project.notes.create( :user_id => current_user, :message => @project_task.name, :message_type => 'created_task')
      respond_to do |format|
        format.html { redirect_to project_project_task_path(@project_task.project,@project_task) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js
      end
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
      respond_to do |format|
        format.html { redirect_to project_project_tasks_path(@project) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js
      end
    end
  end
  
  def destroy
    @project_task = ProjectTask.find(params[:id])
    @project_task.destroy
    flash[:notice] = "Successfully destroyed projecttask."
    respond_to do |format|
      format.html { redirect_to project_project_tasks_path(@project) }
      format.js { 
        logger.info("**** AJAX CALL *****" )
      }
    end
  end
  
  private
  def load_project
    #raise params.inspect
    params[:project_id] ||= params[:project_task][:project_id] if params[:project_task]
    params[:project_id] ||= params[:search][:project_id] if params[:search] && params[:search][:project_id]
    @project ||= Project.find(params[:project_id],:include => [:user,:project_tasks])
  end
end
