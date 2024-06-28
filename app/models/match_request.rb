class MatchRequest < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User'

  enum :status, %i(pending accepted denied)

  def accept!
    self.accepted!

    match = Match.create(user_id: sender_id, matchee_id: receiver_id)

    PushNotification.create(
      user_id: self.receiver_id,
      event_name: 'new_match',
      content: "You've matched with #{self.sender.first_name}!"
    )

    PushNotification.create(
      user_id: self.sender_id,
      event_name: 'new_match',
      content: "You've matched with #{self.receiver.first_name}!"
    )

    conversation = Conversation.create(match_id: match.id)
    self.sender.conversations << conversation
    self.receiver.conversations << conversation

    sender.save!
    receiver.save!
  end

  def decline!
    self.denied!
  end
end
