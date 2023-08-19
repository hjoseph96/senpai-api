# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :phone, String, null: false
    field :first_name, String, null: false
    field :birthday, GraphQL::Types::ISO8601DateTime
    field :encrypted_password, String, null: false
    field :sign_in_count, Integer, null: false
    field :current_sign_in_at, GraphQL::Types::ISO8601DateTime
    field :last_sign_in_at, GraphQL::Types::ISO8601DateTime
    field :current_sign_in_ip, String
    field :last_sign_in_ip, String
    field :online_status, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :gender, Integer
    field :desired_gender, Integer
    field :lonlat, String
    field :bio, String
    field :school, String
    field :occupation, String
    field :spotify_email, String
    field :premium, Boolean, null: false
    field :verified, Boolean, null: false
    field :role, String, null: false
    field :display_city, String
    field :display_state, String

    field :animes, [Types::AnimeType]
    field :matches, [Types::MatchType]
    field :gallery, Types::GalleryType
    field :favorite_music, [Types::FavoriteMusicType]

    def animes
      UserAnime.where(user_id: object.id).order(:order).map(&:anime)
    end

    def matches
      object.matches
    end

    def gallery
      object.gallery
    end

    def favorite_music
      object.favorite_music
    end
  end
end
