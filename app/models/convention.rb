class Convention < ApplicationRecord
  has_many :user_conventions
  has_many :attendees, through: :user_conventions, source: 'user'
  has_many :events
  has_many :parties, through: :events
  has_many :reviews, as: :reviewable

  validates :title, presence: true
  validates :start_date, presence: true

  has_one_attached :cover_image

  include PgSearch::Model
  pg_search_scope :search_by_title, against: [:title],  using: { trigram: { threshold: 0.1 } }


  scope :within, -> (latitude, longitude, distance_in_mile = 1) {
    where(%{
     ST_Distance(lonlat, 'POINT(%f %f)') < %d
    } % [longitude, latitude, distance_in_mile * 1609.34]) # approx
  }
end
