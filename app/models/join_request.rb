class JoinRequest < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :conversation, optional: true

  enum :status, [:pending, :approved, :denied]

  def mark_approved
    return if party.event.is_full?

    self.approved!

    party = self.event.party
    party.members << self.user

    if party.save!
      party.full! if party.event.is_full?
    end
  end
end
