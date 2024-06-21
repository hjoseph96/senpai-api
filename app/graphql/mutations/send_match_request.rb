# frozen_string_literal: true

module Mutations
  class SendEventInvite < Mutations::BaseMutation
    graphql_name "SendMatchRequest"

    argument :sender_id, ID, required: true
    argument :receiver_id, ID, required: true

    field :match_request, Types::MatchRequestType, null: false

    def resolve(sender_id:, receiver_id:)
      @sender = User.find(sender_id)
      @receiver = User.find(receiver_id)

      begin
        @invite = MatchRequest.new(
          sender_id: @sender.id,
          receiver_id: @receiver.id
        )

        if @invite.save!
          PushNotification.create!(
            user_id: @receiver.id,
            event_name: 'match_request_received',
            content: "#{@sender.first_name} invited you to match!"
          )

          { match_request: @invite.reload }
        end
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end