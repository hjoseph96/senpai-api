class Convention < ApplicationRecord
  has_many :user_conventions
  has_many :attendees, through: :user_conventions, foreign_key: :user_id, class_name: 'User'
  has_many :events
  has_many :parties, through: :events

  validates :title, presence: true
  validates :start_date, presence: true

  has_one_attached :cover_image

  scope :within, -> (latitude, longitude, distance_in_mile = 1) {
    where(%{
     ST_Distance(lonlat, 'POINT(%f %f)') < %d
    } % [longitude, latitude, distance_in_mile * 1609.34]) # approx
  }
end
