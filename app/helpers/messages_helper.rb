module MessagesHelper
  def recipient_checkboxes(message,recipients=[])
    message.user.commited_friendships.map { |r|
      NBSP*3+
      check_box_tag( "message[recipient_ids][]", r.friend_of(message.user).id.to_s, recipients.include?(r.friend_of(message.user).id.to_s) ) + NBSP + 
        r.friend_of(message.user).fullname.gsub(/\s/,NBSP)
    }.join(" ")
  end
end
