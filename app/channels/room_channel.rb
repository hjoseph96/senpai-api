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

    def enter(data)
      room_id   = data['room_id']
      convo = get_convo(room_id) # A conversation is a room

      convo.messages.where.not(sender_id: current_user.id).update(read: true)
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
  
      # saves the message and its data to the DB
      m = Message.new(
        conversation: convo,
        sender: sender,
        content: message
      )

      m.sticker_id = data['sticker_id'] if data['sticker_id'].present?
      m.reaction = data['reaction'] if data['reaction'].present?

      # Message gets broadcast after successful DB creation
      m.save!
    end
    
    # Helpers
    
    def get_convo(room_code)
      Conversation.find(room_code)
    end
end