# frozen_string_literal: true

module Types
  class PhotoType < Types::BaseObject
    field :id, ID, null: false
    field :gallery_id, Integer, null: false
    field :order, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :url, String, null: false

    def url
      Rails.application.routes.url_helpers.rails_blob_path(object.image)
    end
  end
end
