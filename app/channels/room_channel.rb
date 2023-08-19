class RoomChannel < ApplicationCable::Channel
    # calls when a client connects to the server
    def subscribed
      if params[:room_id].present?
        c = get_convo(params[:room_id])

        # creates a private chat room with a unique name
        stream_from("ChatRoom-#{(params[:room_id])}")

        c.messages.order(created_at: :desc)
      end
    end

    def unsubscribed
    end
    
    # calls when a client broadcasts data
    def speak(data)
      sender    = current_user
      room_id   = data['room_id']
      message   = data['message']
  
      raise 'No room_id!' if room_id.blank?
      convo = get_convo(room_id) # A conversation is a room
      raise 'No conversation found!' if convo.blank?
      raise 'No message!' if message.blank?
  
      # adds the message sender to the conversation if not already included
      convo.users << sender unless convo.users.include?(sender)
      # saves the message and its data to the DB
      
      # Note: this does not broadcast to the clients yet!
      Message.create!(
        conversation: convo,
        sender: sender,
        content: message
      )
    end
    
    # Helpers
    
    def get_convo(room_code)
      Conversation.find(room_code)
    end
end