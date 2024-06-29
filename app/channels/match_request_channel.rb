class MatchRequestChannel < ApplicationCable::Channel
  def subscribed
    stream_from "MatchRequest-#{current_user.id}"
  end
end