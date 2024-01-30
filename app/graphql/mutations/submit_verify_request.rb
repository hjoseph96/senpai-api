# frozen_string_literal: true

module Mutations
    class SubmitVerifyRequest < Mutations::BaseMutation
      graphql_name "SubmitVerifyRequest"
  
      argument :params, Types::Input::VerifyRequestInputType, required: true

      field :user, Types::UserType, null: false
  
      def resolve(params:)
        unless context[:ready?]
          raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
        end

        @current_user = context[:current_user]

        verify_params = Hash params

        file = verify_params[:image]
        blob = ActiveStorage::Blob.create_and_upload!(
            io: file.tempfile,
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