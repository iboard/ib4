class TaskActionsController < ApplicationController
  
  before_filter :load_user
  filter_resource_access 
  
  def index
    @task_actions = @user.task_actions.all(:include => [:action_contexts,:user])
  end
  
  def show
    @task_action = TaskAction.find(params[:id])
  end
  
  def new
    @task_action = @user.task_actions.build(:project_task_id => params[:project_task_id])
    @task_action.date_due = @task_action.project_task.date_due if @task_action.project_task
  end
  
  def create
    @task_action = TaskAction.new(params[:task_action])
    @task_action.user = @user
    if @task_action.save
      flash[:notice] = "Successfully created taskaction."
      redirect_to @task_action
    else
      render :action => 'new'
    end
  end
  
  def edit
    @task_action = TaskAction.find(params[:id])
  end
  
  def update
    @task_action = TaskAction.find(params[:id])
    if @task_action.update_attributes(params[:task_action])
      flash[:notice] = "Successfully updated taskaction."
      redirect_to @task_action
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @task_action = TaskAction.find(params[:id])
    @task_action.destroy
    flash[:notice] = "Successfully destroyed taskaction."
    respond_to do |format|
      format.html { redirect_to task_actions_url }
      format.js {}
    end
  end
  
  private
  def load_user
    if is_admin?
      @user = User.find(params[:user_id]) if params[:user_id]
    end
    @user ||= current_user
  end
end
