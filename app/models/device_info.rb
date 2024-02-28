class DeviceInfo < ApplicationRecord
  belongs_to :user

  enum :device_type, [:ios, :android]

  def self.send_notification(tokens, payload, device_type='android')
    messenger = (device_type == :android ? PushMessenger::Gcm.new : PushMessenger::Ios.new)

    begin
      messenger.deliver("#{device_type.to_s}_app", tokens, payload)
    rescue Exception => error
      Rails.logger.debug error
    end
  end
end
