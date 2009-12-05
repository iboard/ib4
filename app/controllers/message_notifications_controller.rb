class MessageNotificationsController < ApplicationController
  def index
    @message_notifications = MessageNotification.all
  end
  
  def show
    @message_notification = MessageNotification.find(params[:id])
  end
  
  def new
    @message_notification = MessageNotification.new
  end
  
  def create
    @message_notification = MessageNotification.new(params[:message_notification])
    if @message_notification.save
      flash[:notice] = "Successfully created messagenotification."
      redirect_to @message_notification
    else
      render :action => 'new'
    end
  end
  
  def edit
    @message_notification = MessageNotification.find(params[:id])
  end
  
  def update
    @message_notification = MessageNotification.find(params[:id])
    if @message_notification.update_attributes(params[:message_notification])
      flash[:notice] = "Successfully updated messagenotification."
      redirect_to @message_notification
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @message_notification = MessageNotification.find(params[:id])
    @message_notification.destroy
    flash[:notice] = "Successfully destroyed messagenotification."
    redirect_to message_notifications_url
  end
  
  def mark_read
    @message_notification = current_user.message_notifications.find(params[:id])
    @message_notification.read_at = @message_notification.read_at.nil? ? Time.now : nil
    @message_notification.save
    logger.info("*** MESSAGE MARKED AS READ notification=#{@message_notification.inspect}\n")
    render :nothing => true
  end
end
