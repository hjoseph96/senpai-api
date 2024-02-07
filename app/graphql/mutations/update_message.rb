# frozen_string_literal: true

module Mutations
  class UpdateMessage < Mutations::BaseMutation
    graphql_name "UpdateMessage"

    argument :params, Types::Input::MessageUpdateInputType, required: true

    field :message, Types::MessageType, null: false

    def resolve(params:)
      @message = Message.find(params[:message_id])

      begin
        update_params = Hash params
        update_params.delete(:message_id)

        @message.update!(update_params)

        reacted_user = @message.conversation.users.where.not(id: @message.sender_id).first


        if update_params[:reaction].present?
          PushNotification.create!(
            user_id: reacted_user.id,
            event_name: 'message_reaction',
            content: "#{reacted_user.first_name} reacted to your message."
          )
        end

        { message: @message.reload }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end