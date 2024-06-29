class RejectMatchRequestBroadcastJob
  include Sidekiq::Job
  include ApplicationHelper

  def perform(match_request_id)
    match_request = MatchRequest.find(match_request_id)

    payload = {
      match_request_id: match_request.id,
      sender_id: match_request.sender_id,
      receiver_id: match_request.receiver_id,
      status: match_request.status
    }

    ActionCable.server.broadcast(build_channel_id(match_request.sender_id), payload)
  end

  def build_channel_id(id)
    "MatchRequest-#{id}"
  end
end
