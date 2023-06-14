# frozen_string_literal: true

module Types
  class FavoriteMusicType < Types::BaseObject
    field :id, ID, null: false
    field :music_type, Integer
    field :cover_url, String
    field :name, String
    field :user_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :cover, String

    def cover
      rails_blob_path(favorite_music.cover, only_path: true)
    end
  end
end
