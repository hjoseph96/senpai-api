# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :phone, String, null: false
    field :encrypted_password, String, null: false
    field :sign_in_count, Integer, null: false
    field :current_sign_in_at, GraphQL::Types::ISO8601DateTime
    field :last_sign_in_at, GraphQL::Types::ISO8601DateTime
    field :current_sign_in_ip, String
    field :last_sign_in_ip, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :gender, Integer
    field :desired_gender, Integer
    field :bio, String

    field :animes, [Types::AnimeType]
    field :matches, [Types::MatchType]
    field :gallery, [String]

    def animes
      current_user.animes
    end

    def matches
      current_user.matches
    end

    def gallery
      current_user.gallery.map {|img| rails_blob_path(object.image, only_path: true) }
    end
  end
end
