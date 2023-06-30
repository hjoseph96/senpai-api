class VerifyRequest < ApplicationRecord
  belongs_to :user

  has_one_attached :submitted_photo

  enum :status, [ :pending, :approved, :denied ]

  def approve
    self.approved!

    # TODO: puah notification
  end

  def deny
    seld.denied!

    # TODO: puah notification
  end
end
