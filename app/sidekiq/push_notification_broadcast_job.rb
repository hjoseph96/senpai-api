class PushNotificationBroadcastJob
  include Sidekiq::Job
  include ApplicationHelper

  def perform(push_notification_id)
    notification = PushNotification.find(push_notification_id)

    payload = {
      id: notification.id,
      user_id: notification.user.id,
      event_name: notification.event_name,
      content: notification.content
    }

    ActionCable.server.broadcast(build_channel_id(notification.user.id), payload)
  end

  def build_channel_id(id)
    "Notification-#{id}"
  end
end
