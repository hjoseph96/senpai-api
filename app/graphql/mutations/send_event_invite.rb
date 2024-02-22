# frozen_string_literal: true

module Mutations
  class SendEventInvite < Mutations::BaseMutation
    graphql_name "SendEventInvite"

    argument :sender_id, ID, required: true
    argument :receiver_id, ID, required: true
    argument :event_id, ID, required: true
    argument :content, String, required: false

    field :event_invite, Types::EventInviteType, null: false

    def resolve(sender_id:, receiver_id:, event_id:, content: '')
      @sender = User.find(sender_id)
      @receiver = User.find(receiver_id)
      @event = Event.find(event_id)

      begin
        @invite = EventInvite.new(
          event_id: event_id,
          sender_id: @sender.id,
          receiver_id: @receiver.id
        )
        @invite.content = content if content.present?

        if @invite.save!
          PushNotification.create!(
            user_id: @receiver.id,
            event_name: 'invite_received',
            content: "#{@sender.first_name} invited you to an event!"
          )

          { event_invite: @invite.reload }
        end
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end