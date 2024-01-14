class Recommendation < ApplicationRecord
  belongs_to :user
  belongs_to :anime
  belongs_to :message, dependent: :destroy
end
