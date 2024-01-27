class Match < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :matchee, foreign_key: :matchee_id, class_name: 'User'
  has_one :conversation
end
