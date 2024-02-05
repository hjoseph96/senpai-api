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

    trigger_fcm_notification(notification)
  end

  def build_channel_id(id)
    "Notification-#{id}"
  end

  def blacklist_event_names
    %w(reset_message unmatched_user)
  end

  def trigger_fcm_notification(notif)
    # Don't bother sending FCM requests for these event_types
    return if blacklist_event_names.include?(notif.event_name)

    client = FcmService.new(notification: notif)
    client.send_fcm_push_notification
  end
end
