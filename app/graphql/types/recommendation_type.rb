# frozen_string_literal: true

module Types
  class RecommendationType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :recommendee_id, Integer, null: false
    field :anime_id, Integer, null: false
    field :message_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :anime, Types::AnimeType

    def message
      object.anime
    end
  end
end
