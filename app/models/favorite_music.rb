class FavoriteMusic < ApplicationRecord
  belongs_to :user
  
  has_one_attached :cover

  enum :music_type, [ :artist, :track ]
end
