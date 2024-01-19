class FavoriteMusic < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  
  enum :music_type, [ :artist, :track ]
end
