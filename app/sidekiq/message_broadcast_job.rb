class MessageBroadcastJob
  include Sidekiq::Job
  include ApplicationHelper

  def perform(message_id)
    message = Message.find(message_id)
    
    payload = {
      room_id: message.conversation.id,
      content: message.content,
      sender: message.sender,
      participants: message.conversation.users.pluck(:id)
    }

    payload.merge!({ attachment: cdn_for(message.attachment) }) if message.attachment.present?
    payload.merge!({ sticker: cdn_for(message.sticker.image) }) if message.sticker_id.present?
    payload.merge!({ recommendation: message.recommendation }) if message.recommendation.present?

    ActionCable.server.broadcast(build_room_id(message.conversation.id), payload)
  end
  
  def build_room_id(id)
    "ChatRoom-#{id}"
  end
end
