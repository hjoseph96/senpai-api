# frozen_string_literal: true

module Types
  class FavoriteMusicType < Types::BaseObject
    include ApplicationHelper

    field :id, ID, null: false
    field :music_type, String
    field :cover_url, String
    field :name, String
    field :user_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :cover_url, String
  end
end
