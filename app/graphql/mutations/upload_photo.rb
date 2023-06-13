# frozen_string_literal: true

module Mutations
    class UploadPhoto < Mutations::BaseMutation
      graphql_name "UploadPhoto"
  
      argument :user_id, Integer, required: true
      argument :image, ApolloUploadServer::Upload, required: true
      argument :order, Integer, required: true

      field :user, Types::UserType, null: false
  
      def resolve(params:)
        @current_user = User.find(params[:user_id])

        file = input[:image]
        blob = ActiveStorage::Blob.create_and_upload!(
            io: file,
            filename: file.original_filename,
            content_type: file.content_type
        )
        photo = Photo.new
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