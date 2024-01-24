# frozen_string_literal: true

module Types
  class GalleryType < Types::BaseObject
    include Rails.application.routes.url_helpers

    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :photos, [Types::PhotoType]

    def photos
      dataloader.with(Sources::PhotosByGalleryId).load(object.id)
    end
  end
end
