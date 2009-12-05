class MessagesController < ApplicationController
  
  filter_resource_access
  before_filter :load_user
  before_filter :setup_recipients, :only => [:new,:create]
  
  def index
    @messages = @user.messages.descend_by_updated_at
  end
  
  def show
    @message = @usser.messages.find(params[:id])
  end
  
  def new
    @message = @user.messages.build
  end
  
  def create
    @message = @user.messages.build(params[:message])
    if @message.save
      flash[:notice] = t(:message_sent)
      redirect_to  params[:back_to].blank? ? root_path : params[:back_to]
    else
      render :action => 'new', :recipient_ids => params[:message][:recipient_ids]
    end
  end
  
  def edit
    @message = Message.find(params[:id])
  end
  
  def update
    @message = Message.find(params[:id])
    if @message.update_attributes(params[:message])
      flash[:notice] = "Successfully updated message."
      redirect_to @message
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    flash[:notice] = "Successfully destroyed message."
    redirect_to messages_url
  end
  
  private
  def load_user
    @user ||= current_user
  end
  
  def setup_recipients
    if params[:message] && params[:message][:recipient_ids] 
      @recipients = params[:message][:recipient_ids] 
    else
      @recipients = [ params[:recipient] ]
    end
  end
end
