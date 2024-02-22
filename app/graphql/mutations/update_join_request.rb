module Mutations
  class UpdateJoinRequest < Mutations::BaseMutation
    argument :params, Types::Input::JoinRequestInputType, required: true

    field :join_request, Types::JoinRequestType, null: false

    def resolve(params:)
      join_params = Hash params

      begin
        @join_request = JoinRequest.find(join_params[:join_request_id])

        if join_params[:status].present?
          return unless %w(approved denied).include? join_params[:status]

          case join_params[:status]
            when 'approved'
              @join_request.approved!

              PushNotification.create!(
                user_id: @join_request.user_id,
                event_name: 'accepted_to_party',
                content: "#{@join_request.event.host.first_name} accepted you into their party!"
              )
            when 'denied' then @join_request.denied!
          end
        end

        { join_request: @join_request.reload }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("#{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end