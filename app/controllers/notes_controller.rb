class NotesController < ApplicationController
  
  before_filter  :load_user, :except => [:mark_read,:mark_all_read]
  before_filter  :require_admin, :except => [:index,:create,:destroy,:mark_read,:mark_all_read]
  before_filter  :require_owner_or_admin, :except => [:index,:create,:new,:destroy,:update,:mark_read,:mark_all_read]
  
  def index
    if params[:message_type] == 'end_action' && params[:noteable_type] == 'User'
      # Session History
      @notes = @user.notes.find(:all, :conditions => ['noteable_type = ? and message_type = ?', 'User',:end_action]
                               ).paginate(:page => params[:page], :per_page => PROJECT_NOTES_PER_PAGE)
      render :session_history
      return
    else
      # Standard Notes-Index
      params[:search] = {:order => 'descend_by_updated_at'} unless params[:search]
      if find_noteable
        @search =find_noteable.notes.search(params[:search])
      else
        @search = Note.search(params[:search])
      end
      @notes = @search.find(:all,:conditions => 'parent_id is null').paginate(:page => params[:page], :per_page => PROJECT_NOTES_PER_PAGE)
    end
  end
  
  def show
    @note = find_noteable.notes.find(params[:id])
  end
  
  def new
    @note = @user.notes.new
  end
  
  def create
    params[:note][:user_id] ||= current_user.id
    @note = find_noteable.notes.build(params[:note])
    if @note.save
      flash.now[:notice] = "Successfully created note."
    end
  end
  
  def edit
    @note = find_noteable.notes.find(params[:id])
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
    respond_to do |format|
      format.html { redirect_to notes_url }
      format.js 
    end
  end
  
  def clear_session_log
    if params[:message_type] == 'end_action' && params[:noteable_type] == 'User'
      @notes = @user.notes.find(:all, :conditions => ['noteable_type = ? and message_type = ?', 'User',:end_action])
    else
      @notes = @user.notes.all if is_admin?
    end
    @notes.each(&:delete)
    flash[:notice] = t(:session_history_cleared)
    redirect_to user_notes_path(current_user,:message_type=>'end_action',:noteable_type=>'User')
  end
  
  def mark_read
    @note = Note.find(params[:id])
    @user = User.find(params[:user_id])
    confirm_note = @note.children.build(
      :noteable_type => @note.noteable_type,
      :noteable_id => @note.noteable_id,
      :message_type => 'confirm_read',
      :message => '',
      :user_id => @user.id
    )
    confirm_note.save(false)
    render :text => params.inspect, :layout => false
  end
  
  def mark_all_read
    @user = User.find(params[:user_id])
    @user.project_notes.each do |note|
      confirm_note = note.children.build(
        :noteable_type => note.noteable_type,
        :noteable_id => note.noteable_id,
        :message_type => 'confirm_read',
        :message => '',
        :user_id => @user.id
      )
      confirm_note.save(false)
    end
  end
  
  private
  def find_noteable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
  
  def load_user
    if is_admin? && params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
  end
  
  def require_owner_or_admin
    params[:user_id] ||= current_user.id
    @note = @user.notes.find(params[:id]) if @user && params[:id]
    unless  is_admin? || ( @note && @note.user == current_user ) 
      flash[:error] = t(:access_denied)
      redirect_to root_path
      return false
    end
  end
end
