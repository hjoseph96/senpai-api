# frozen_string_literal: true

module Types
  class GalleryType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :gallery, [String], null: false

    def gallery
      object.images.order(order: :desc).map {|img| rails_blob_path(img, only_path: true) }
    end
  end
end
