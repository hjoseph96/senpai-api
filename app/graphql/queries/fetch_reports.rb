module Queries
  class FetchReports < Queries::BaseQuery
    graphql_name "FetchReports"

    argument :user_id, ID, required: true
    argument :page, Integer, required: false
    argument :per_page, Integer, required: false
    argument :reason, Integer, required: false

    type [Types::ReportType], null: false

    def resolve(user_id:, page: 1, per_page: 50, reason:)
      @current_user = User.find(user_id)

      if @current_user.present? && @current_user.on_the_team?
        results = Report.all.order(created_at: :desc)

        results = results.where(reason: reason) if reason.present?

        results.page(page).per(per_page)
      else
        GraphQL::ExecutionError.new("No admin or mod found")
      end
    end
  end
end
