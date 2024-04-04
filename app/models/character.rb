class Character < ApplicationRecord
  belongs_to :anime

  has_many :red_corner_battles, as: :red_cornerable, class_name: 'Battle'
  has_many :blue_corner_battles, as: :blue_cornerable, class_name: 'Battle'

  enum :gender, [:male, :female]

  has_one_attached :image

  include PgSearch::Model
  pg_search_scope :search_by_full_name, against: [:first_name, :last_name, :japanese_full_name], using: { trigram: { threshold: 0.1 } }
end
