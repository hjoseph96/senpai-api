class JoinRequest < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum :status, [:pending, :approved, :denied]
end
