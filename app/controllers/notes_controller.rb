class NotesController < ApplicationController
  
  before_filter  :load_user
  before_filter  :require_admin, :except => [:index]
  before_filter  :require_owner_or_admin, :except => [:index]
  
  def index
    if params[:message_type] == 'end_action' && params[:noteable_type] == 'User'
      @notes = @user.notes.find(:all, :conditions => ['noteable_type = ? and message_type = ?', 'User',:end_action])
      render :session_history
      return
    else
      @notes = @user.notes.all
    end
  end
  
  def show
    @note = @user.notes.find(params[:id])
  end
  
  def new
    @note = @user.notes.new
  end
  
  def create
    @note = @user.notes.build(params[:note])
    if @note.save
      flash[:notice] = "Successfully created note."
      redirect_to @note
    else
      render :action => 'new'
    end
  end
  
  def edit
    @note = @user.notes.find(params[:id])
  end
  
  def update
    @note = @user.notes.find(params[:id])
    if @note.update_attributes(params[:note])
      flash[:notice] = "Successfully updated note."
      redirect_to @note
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @note = @user.notes.find(params[:id])
    @note.destroy
    flash[:notice] = "Successfully destroyed note."
    redirect_to notes_url
  end
  
  private
  def load_user
    @user = is_admin? ? User.find(params[:user_id]) : current_user
  end
  
  def require_owner_or_admin
    params[:user_id] ||= current_user.id
    @note = @user.notes.find(params[:id]) if @user && params[:id]
    if  !is_admin? && ((!@note) || (@note.user != current_user))
        flash[:error] = t(:access_denied)
        redirect_to root_path
        return false
    end
  end
end
