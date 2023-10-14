# frozen_string_literal: true

module Mutations
    class ReorderPhotos < Mutations::BaseMutation
      graphql_name "ReorderPhotos"
  
      argument :photo_id, ID, required: true
      argument :order, ID, required: true

      field :photo, Types::PhotoType, null: false
      field :gallery, Types::GalleryType

      def resolve(photo_id:, order:)
        @photo = Photo.find(photo_id)

        @photo.update!(order: order)

        { photo: @photo, gallery: @photo.gallery }
      end
    end
end