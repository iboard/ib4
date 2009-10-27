class CommentsController < ApplicationController
  
  before_filter :require_user, :except => [:index,:show]
  
  def index
    unless params[:user_id]
      @comments = Comment.descend_by_updated_at.paginate(:page => params[:page], :per_page => POSTINGS_PER_PAGE)
    else
      @user = User.find(params[:user_id])
      @comments = @user.comments.descend_by_updated_at.paginate(:page => params[:page], :per_page => POSTINGS_PER_PAGE)
    end
  end
  
  def show
    @comment = Comment.find(params[:id])
  end
  
  def new
    @comment = Comment.new
  end
  
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user unless current_user.nil?
    if @comment.save
      flash[:notice] = t(:successfully_created_comment)
      @comment.send_later(
        :deliver_comment_notification,
        t(:commentable_commented, :title => @comment.commentable.list_title(60), :username => @comment.user.username),
        "http://#{LOCALHOST_NAME}/#{@comment.commentable_type.pluralize.downcase}/#{@comment.commentable_id}"
      )
      respond_to do |format|
        format.html { redirect_to @commentable }
        format.js
      end
    else
      render :action => 'new'
    end
  end
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      redirect_to @comment
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    commentable = @comment.commentable
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    respond_to do |format|
      format.html { redirect_to commentable }
    end
  end
  
  private
  def find_commentable
    params.each do |name,value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
  end
end
