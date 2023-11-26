# frozen_string_literal: true

module Mutations
    class ReportUser < Mutations::BaseMutation
      graphql_name "ReportUser"
  
      argument :params, Types::Input::ReportInputType, required: true

      field :blocked, Boolean, null: false
      field :report, Types::ReportType, null: false

      def resolve(params:)
        report_params = Hash params

        @current_user = User.find(report_params[:user_id])

        begin
            r = Report.create!(
                user_id: report_params[:user_id],
                offense_id: report_params[:offense_id],
                reason: report_params[:reason],
                conversation_id: report_params[:conversation_id]
            )

            Block.create(
                blocker_id: report_params[:user_id],
                blockee_id: report_params[:offense_id],
                report_id: r.id
            )

            Match.where(user_id: @current_user.id, matchee_id: report_params[:offense_id]).destroy_all

            { blocked: true, report: r }
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
end