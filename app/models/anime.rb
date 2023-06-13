class Anime < ApplicationRecord
  has_one_attached :cover_image

  serialize :title, JSON
  serialize :genres, JSON
  serialize :studios, JSON
end
