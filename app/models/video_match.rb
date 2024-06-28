class VideoMatch < ApplicationRecord
  belongs_to :user
  belongs_to :matchee, foreign_key: :matchee_id, class_name: 'User'

  has_many :reviews, as: :reviewable
end
