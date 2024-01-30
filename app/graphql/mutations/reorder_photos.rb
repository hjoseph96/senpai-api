# frozen_string_literal: true

module Mutations
    class ReorderPhotos < Mutations::BaseMutation
      graphql_name "ReorderPhotos"
  
      argument :photo_id, ID, required: true
      argument :order, ID, required: true

      field :photo, Types::PhotoType, null: false
      field :gallery, Types::GalleryType

      def resolve(photo_id:, order:)
        unless context[:ready?]
          raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
        end

        @current_user = context[:current_user]

        @photo = @current_user.photos.find(photo_id)

        @photo.update!(order: order)

        { photo: @photo, gallery: @photo.gallery }
      end
    end
end