class Match < ApplicationRecord
  belongs_to :user
  belongs_to :matchee, foreign_key: :matchee_id
  has_one :conversation, dependent: :destroy
end
