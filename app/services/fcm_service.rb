require 'fcm'

class FcmService
  def initialize(notification:)
    @notif = notification
    @user = notification.user
  end

  def send_fcm_push_notification
    payload = {
      priority: 'high',
      data: { message: @notif.event_name },
      notification: {
        body: @notif.content,
        # sound: 'default',
      }
    }

    @user.device_infos.each do |info|
      DeviceInfo.send_notification([info.token], payload, info.device_type)
    end
  end
end