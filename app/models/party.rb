class Party < ApplicationRecord
  belongs_to :event
  belongs_to :host, foreign_key: :host_id, class_name: 'User'

  has_many :user_parties
  has_many :members, through: :user_parties, source: 'user'

  has_one :party_chat
  has_many :reviews, as: :reviewable

  enum  :status, [:open, :full]


  def all_participants
    user_ids = [self.host, members].flatten.map(&:id)

    User.where(id: user_ids)
  end

  def is_full?
    self.members.count == self.member_limit
  end
end
