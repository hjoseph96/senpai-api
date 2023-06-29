class Match < ApplicationRecord
  belongs_to :user
  has_one :conversation
end
