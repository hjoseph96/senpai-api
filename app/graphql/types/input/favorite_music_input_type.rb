module Types
  module Input
    class FavoriteMusicInputType < Types::BaseInputObject
      argument :user_id, Integer, required: true
      argument :music_type, String, required: true
      argument :cover_url, String, required: true
      argument :name, ID, required: true
    end
  end
end