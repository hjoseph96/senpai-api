class EventInvite < ApplicationRecord
  belongs_to :event

  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User'

  enum :status, [:pending, :accepted, :declined]
end
