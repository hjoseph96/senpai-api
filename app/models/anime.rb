class Anime < ApplicationRecord
  has_many :user_animes
  has_many :users, through: :user_animes
  has_many :recommendations
  has_many :characters

  has_one_attached :cover_image

  serialize :genres, coder: JSON
  serialize :studios, coder: JSON

  include PgSearch::Model
  pg_search_scope :search_by_title, against: [:title, :japanese_title], using: { trigram: { threshold: 0.1 } }
  pg_search_scope :search_by_genre, against: :genres, using: { tsearch: { any_word: true } }
end
