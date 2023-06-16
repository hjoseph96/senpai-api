# frozen_string_literal: true

module Mutations
    class SendMessage < Mutations::BaseMutation
      graphql_name "SendMessage"
  
      argument :params, Types::Input::MessageInputType, required: true

      field :message, Types::MessageType, null: false
  
      def resolve(params:)
        @current_user = User.find(params[:sender_id])

        begin
          @conversation = Conversation.where(match_id: params[:match_id])[0]
          @message = Message.new(
              sender_id: params[:sender_id],
              content: params[:content],
              conversation_id: @conversation.id
          )

          @conversation.messages << @message
          @conversation.save!

          { message: @message }
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
end