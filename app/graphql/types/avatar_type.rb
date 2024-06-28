# frozen_string_literal: true

module Types
  class AvatarType < Types::BaseObject
    include ApplicationHelper

    field :id, ID, null: false
    field :guid, String
    field :name, String
    field :gender, String
    field :product_id, String
    field :is_default, Boolean
    field :user_id, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :photo_url, String
    field :thumbnail_url, String

    def photo_url
      cdn_for(object.photo)
    end

    def thumbnail_url
      cdn_for(object.thumbnail)
    end
  end
end
