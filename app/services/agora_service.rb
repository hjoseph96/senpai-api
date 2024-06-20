require 'dynamic_key'
class AgoraService
  EXPIRATION_TIME_IN_SECONDS = 86400

  def self.generate_rtc_token(channel_name = 'Test', user_id = 0)
    params = {
      app_id: Rails.application.credentials.agora_id,
      app_certificate: Rails.application.credentials.agora_certificate,
      channel_name: channel_name,
      uid: user_id, # important: 0 for testing
      role: AgoraDynamicKey::RTCTokenBuilder::Role::PUBLISHER,
      privilege_expired_ts: Time.now.to_i + EXPIRATION_TIME_IN_SECONDS
    }

    AgoraDynamicKey::RTCTokenBuilder.build_token_with_uid params
  end

end