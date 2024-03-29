class Tournament < ApplicationRecord
  belongs_to :user, optional: true

  has_many :rounds, dependent: :destroy

  has_one_attached :cover_image

  enum tournament_type: [:anime, :characters]
  enum combatant_count: %w[2 4 8 16 32]
end
