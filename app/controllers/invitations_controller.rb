class InvitationsController < ApplicationController
  before_filter :require_admin, :except => [:new,:create]
  def index
    @invitations = Invitation.descend_by_updated_at.paginate(:page => params[:page], :per_page => 20 )
  end
  
  def show
    @invitation = Invitation.find(params[:id])
  end
  
  def new
    @invitation = current_user.sent_invitations.build
  end
  
  def create
    @sender = User.find(params[:user_id])
    @invitation = @sender.sent_invitations.build(params[:invitation])
    if @invitation.save
      flash[:notice] = t(:invitation_sent)
      Delayed::Job.enqueue(
#      (:sender,:recipient_email,:subject,:message,:hostname,:register_url,:client_ip)
        InvitationMail.new(
          @sender.id,
          params[:invitation][:recipient_email],
          t(:your_invited_by_name,:name => @sender.fullname),
          params[:invitation][:message],
          request.env['SERVER_NAME'],
          register_url(@invitation.token),
          request.env['REMOTE_ADDR']
        )
      )
      respond_to do |format|
         format.html { redirect_to @sender }
         format.js
      end
    else
      flash[:error] = t(:sending_invitation_failed, :error => @invitation.errors.map{|e| e[0]+":"+e[1]}.join("<br/>"))
      respond_to do |format|
         format.html { render :action => 'new' }
         format.js
      end
    end
  end
  
  def edit
    @invitation = Invitation.find(params[:id])
  end
  
  def update
    @invitation = Invitation.find(params[:id])
    if @invitation.update_attributes(params[:invitation])
      flash[:notice] = "Successfully updated invitation."
      redirect_to @invitation
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy
    flash[:notice] = "Successfully destroyed invitation."
    redirect_to invitations_url
  end
end
