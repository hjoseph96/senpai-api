# frozen_string_literal: true

module Mutations
    class SubmitVerifyRequest < Mutations::BaseMutation
      graphql_name "SubmitVerifyRequest"
  
      argument :params, Types::Input::VerifyRequestInputType, required: true

      field :user, Types::UserType, null: false
  
      def resolve(params:)
        verify_params = Hash params
        @current_user = User.find(verify_params[:user_id])

        file = verify_params[:image]
        blob = ActiveStorage::Blob.create_and_upload!(
            io: file,
            filename: file.original_filename,
            content_type: file.content_type
        )
        request = VerifyRequest.new(user_id: @current_user.id)
        request.submitted_photo.attach(blob)

        if request.save 
            { user: @current_user } 
        else 
            { errors: request.errors.full_messages }
        end
      end
    end
end