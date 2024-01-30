module Queries
  class FetchReports < Queries::BaseQuery
    graphql_name "FetchReports"

    argument :page, Integer, required: false
    argument :per_page, Integer, required: false
    argument :reason, Integer, required: false

    type [Types::ReportType], null: false

    def resolve(page: 1, per_page: 50, reason:)
      unless context[:ready?]
        raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
      end

      @current_user = context[:current_user]

      if @current_user.present? && @current_user.on_the_team?
        results = Report.all.order(created_at: :desc)

        results = results.where(reason: reason) if reason.present?

        results.page(page).per(per_page)
      else
        raise GraphQL::ExecutionError.new("No admin or mod found")
      end
    end
  end
end
