class FavoriteMusic < ApplicationRecord
  belongs_to :user
  
  enum :music_type, [ :artist, :track ]
end
