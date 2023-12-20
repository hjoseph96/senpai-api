class PushNotification < ApplicationRecord
  belongs_to :user

  after_create_commit { PushNotificationBroadcastJob.perform_async(self.id) }
end
