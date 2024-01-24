# frozen_string_literal: true

module Types
  class AnimeType < Types::BaseObject
    include ApplicationHelper

    field :id, ID, null: false
    field :title, String
    field :year, Integer
    field :genres, String
    field :popularity, Integer
    field :average_score, Integer
    field :episodes, Integer
    field :is_adult, Boolean
    field :status, String
    field :studios, String
    field :start_date, GraphQL::Types::ISO8601DateTime
    field :end_date, GraphQL::Types::ISO8601DateTime
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :cover, String
    field :characters, [Types::CharacterType]

    def cover
      cdn_for(object.cover_image)
    end

    def characters
      dataloader.with(Sources::CharactersByAnimeId).load(object.id)
    end
  end
end
