module Mutations
  class UpdateEventInvite < Mutations::BaseMutation
    graphql_name "UpdateEventInvite"

    argument :receiver_id, ID, required: true
    argument :event_invite_id, ID, required: true
    argument :status, String, required: true


    field :event_invite, Types::EventInviteType, null: false

    def resolve(receiver_id:, event_invite_id:, status: )
      @invite = EventInvite.find(event_invite_id)
      @receiver = User.find(receiver_id)

      begin
        unless %w(accepted declined).include?(status)
          return GraphQL::ExecutionError.new("Invalid invite status")
        end

        @invite.status = status

        if @invite.save!
          case status
          when 'accepted'
            @invite.accepted!

            @party = @invite.event.party
            @party.members << @receiver
            @party.save!

            PushNotification.create!(
              user_id: @invite.event.host.id,
              event_name: 'invite_accepted',
              content: "#{@receiver.first_name} has accepted your invite!"
            )
          when 'denied' then @invite.denied!
          end

          { event_invite: @invite.reload }
        end
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("#{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end