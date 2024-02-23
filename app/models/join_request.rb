class JoinRequest < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum :status, [:pending, :approved, :denied]

  def mark_approved
    self.approved!

    party = self.event.party
    party.members << self.user
    party.save!
  end
end
