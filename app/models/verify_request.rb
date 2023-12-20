class VerifyRequest < ApplicationRecord
  belongs_to :user

  has_one_attached :submitted_photo

  enum :status, [ :pending, :approved, :denied ]

  def approve!
    self.approved!

    PushNotification.create(
      user_id: self.user_id,
      event_name: 'verify_request_approve',
      content: 'Your verification has been approved!'
    )
  end

  def deny!
    self.denied!

    PushNotification.create(
      user_id: self.user_id,
      event_name: 'verify_request_deny',
      content: 'Your verification has been approved!'
    )
  end
end
