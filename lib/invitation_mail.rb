class InvitationMail < Struct.new(:sender_id,:recipient_email,:subject,:message,:hostname,:register_url,:client_ip)
  
  def perform
    @sender = User.find(sender_id)
    UserMailer.deliver_account_invitation(@sender,recipient_email,subject,message,hostname,register_url,client_ip)
    @sender.invitations_left -= 1
    @sender.save      
  end
  
end