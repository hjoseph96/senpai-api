class Party < ApplicationRecord
  belongs_to :event
  has_one :host, foreign_key: :host_id, class_name: 'User'

  has_many :user_parties
  has_many :members, through: :user_parties, source: 'user'
end
