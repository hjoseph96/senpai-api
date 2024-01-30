# frozen_string_literal: true

module Mutations
    class ReportUser < Mutations::BaseMutation
      graphql_name "ReportUser"
  
      argument :params, Types::Input::ReportInputType, required: true

      field :blocked, Boolean, null: false
      field :report, Types::ReportType, null: false

      def resolve(params:)
        report_params = Hash params

        unless context[:ready?]
          raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
        end

        @current_user = context[:current_user]

        begin
            r = Report.create!(
                user_id: @current_user.id,
                offense_id: report_params[:offense_id],
                reason: report_params[:reason],
                conversation_id: report_params[:conversation_id]
            )

            Block.create!(
                user_id: @current_user.id,
                blocker_id: @current_user.id,
                blockee_id: report_params[:offense_id],
                report_id: r.id
            )

            Match.where(user_id: @current_user.id, matchee_id: report_params[:offense_id]).destroy_all

            blocked_user = User.find(report_params[:offense_id])
            PushNotification.create!(
              user_id: @current_user.id,
              event_name: 'unmatched_user',
              content: "#{@current_user.first_name} reported #{blocked_user.first_name}"
            )

            { blocked: true, report: r }
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
end