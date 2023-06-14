class VerifyRequest < ApplicationRecord
  belongs_to :user

  has_one_attached :submitted_photo

  enum :status, [ :pending, :approved, :denied ]
end
