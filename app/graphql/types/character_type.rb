# frozen_string_literal: true

module Types
  class CharacterType < Types::BaseObject
    include ApplicationHelper

    field :id, ID, null: false
    field :anime_id, Integer, null: false
    field :first_name, String
    field :last_name, String
    field :favorites, Integer
    field :role, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :image_url, String, null: false

    def url
      cdn_for(object.image)
    end
  end
end
