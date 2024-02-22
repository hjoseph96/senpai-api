class PartyMessageBroadcastJob
  include Sidekiq::Job
  include ApplicationHelper

  def perform(message_id)
    message = PartyMessage.find(message_id)

    payload = {
      room_id: message.party.id,
      content: message.content,
      sender: message.sender,
      participants: message.party.all_participants.pluck(:id)
    }

    payload.merge!({ attachment: cdn_for(message.attachment) }) if message.attachment.present?
    payload.merge!({ sticker: cdn_for(message.sticker.image) }) if message.sticker_id.present?
    payload.merge!({ recommendation: message.recommendation }) if message.recommendation.present?

    ActionCable.server.broadcast(build_room_id(message.party.id), payload)
  end

  def build_room_id(id)
    "PartyChatRoom-#{id}"
  end
end
