# frozen_string_literal: true

module Types
  class GalleryType < Types::BaseObject
    include Rails.application.routes.url_helpers

    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :photo_urls, [String], null: false

    def photo_urls
      object.photos.order(order: :asc).map {|p| Rails.application.routes.url_helpers.rails_blob_path(p.image, only_path: true) }
    end
  end
end
