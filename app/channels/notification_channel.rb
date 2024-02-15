class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "Notification-#{current_user.id}"
  end

  def unsubscribed
    current_user.disappear
  end
end