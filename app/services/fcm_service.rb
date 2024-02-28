require 'fcm'

class FcmService
  def initialize(notification:)
    @notif = notification
    @user = notification.user

    fcm_api_key = Rails.application.credentials.fcm_server_key
    @client = FCM.new(fcm_api_key)
  end

  def send_fcm_push_notification
    options = {
      priority: 'high',
      data: { message: @notif.event_name },
      notification: {
        body: @notif.content,
        # sound: 'default',
      }
    }
    
    @user.device_infos.pluck(:token).each do |device_token|
      response = @client.send(device_token, options)
      puts response
    end
  end
end