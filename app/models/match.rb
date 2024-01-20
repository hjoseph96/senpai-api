class Match < ApplicationRecord
  belongs_to :user
  belongs_to :matchee, foreign_key: :matchee_id, class_name: 'User'
  has_one :conversation, dependent: :delete
end
