# frozen_string_literal: true

module Mutations
    class SendMessage < Mutations::BaseMutation
      graphql_name "SendMessage"
  
      argument :params, Types::Input::MessageInputType, required: true

      field :message, Types::LikeType, null: false
  
      def resolve(params:)
        @current_user = User.find(params[:sender_id])

        begin
            @message = Message.create!(
                sender_id: params[:sender_id],
                content: params[:content],
                match: params[:match_id]
                )

            { message: @message }
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
end