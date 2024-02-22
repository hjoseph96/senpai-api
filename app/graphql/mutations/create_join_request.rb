module Mutations
  class CreateJoinRequest < Mutations::BaseMutation
    argument :params, Types::Input::JoinRequestInputType, required: true

    field :join_request, Types::JoinRequestType, null: false

    def resolve(params:)
      join_params = Hash params

      begin
        @event = Event.find(join_params[:event_id])
        applicant = User.find(join_params[:user_id])

        join_request = JoinRequest.new(
          user_id: applicant.id,
          event_id: @event.id,
        )

        join_request.description = join_params[:description] if join_params[:description].present?

        if join_request.save!
          PushNotification.create!(
            user_id: @event.host_id,
            event_name: 'party_join_request',
            content: "#{applicant.first_name} wants to join your party!"
          )

          { join_request: join_request }
        end
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("#{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end