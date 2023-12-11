module Types
  module Input
    class FavoriteMusicInputType < Types::BaseInputObject
      argument :user_id, Integer, required: true
      argument :music_type, String, required: true
      argument :cover_url, String, required: true
      argument :track_name, String, required: false
      argument :artist_name, String, required: false
    end
  end
end