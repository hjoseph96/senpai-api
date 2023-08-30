class VerifyRequest < ApplicationRecord
  belongs_to :user

  has_one_attached :submitted_photo

  enum :status, [ :pending, :approved, :denied ]

  def approve!
    self.approved!

    # TODO: push notification
  end

  def deny!
    self.denied!

    # TODO: push notification
  end
end
