class Recommendation < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :anime
  belongs_to :message
  belongs_to :party_chat
end
