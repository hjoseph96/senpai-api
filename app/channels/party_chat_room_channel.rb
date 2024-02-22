class PartyChatRoomChannel < ApplicationCable::Channel
  # calls when a client connects to the server
  def subscribed
    if params[:room_id].present?
      stream_from("PartyChatRoom-#{params[:room_id]}")
    end
  end

  def unsubscribed
  end

  def enter(data)
    room_id   = data['room_id']
    party_chat = get_party_chat(room_id)
    party_chat.messages.where.not(sender_id: current_user.id).update(read: true)

    PushNotification.create(
      user_id: current_user.id,
      event_name: 'party_reset_message',
      content: "Unread messages marked as read."
    )
  end

  # calls when a client broadcasts data
  def speak(data)
    sender    = current_user
    room_id   = data['room_id']
    message   = data['message']

    raise 'No room_id!' if room_id.blank?
    chat = get_party_chat(room_id) # A conversation is a room
    raise 'No party chat found!' if convo.nil?
    raise 'No message!' if message.blank?

    # saves the message and its data to the DB
    m = PartyMessage.new(
      party_chat_id: chat.id,
      sender: sender,
      content: message
    )

    m.sticker_id = data['sticker_id'] if data['sticker_id'].present?
    m.reaction = data['reaction'] if data['reaction'].present?

    # Message gets broadcast after successful DB creation
    m.save!
  end

  # Helpers

  def get_party_chat(room_code)
    PartyChat.find(room_code)
  end
end