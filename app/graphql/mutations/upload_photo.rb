# frozen_string_literal: true

module Mutations
    class UploadPhoto < Mutations::BaseMutation
      graphql_name "UploadPhoto"
  
      argument :user_id, Integer, required: true
      argument :image, ApolloUploadServer::Upload, required: false
      argument :order, Integer, required: true

      field :user, Types::UserType, null: false
  
      def resolve(user_id:, image:, order:)
        @current_user = User.find(user_id)

        if @current_user.gallery.nil?
          g = Galley.create
          @current_user.gallery = g
          @current_user.save!
        end

        file = image
        blob = ActiveStorage::Blob.create_and_upload!(
            io: file.tempfile,
            filename: file.original_filename
        )
        photo = Photo.new(order: order)
        photo.image.attach(blob)
        @current_user.gallery.photos << photo

        if @current_user.save 
            { user: @current_user } 
        else 
            { errors: @current_user.errors.full_messages }
        end
      end
    end
end