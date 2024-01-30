module Queries
  class FetchVerifyRequests < Queries::BaseQuery
    graphql_name "FetchVerifyRequests"

    argument :page, Integer, required: false
    argument :per_page, Integer, required: false

    type [Types::VerifyRequestType], null: false

    def resolve(page: 1, per_page: 50)
      unless context[:ready?]
        raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
      end

      @current_user = context[:current_user]

      if @current_user.present?
        results = VerifyRequest.where(user_id: user_id).order(created_at: :desc)

        results.page(page).per(per_page)
      else
        GraphQL::ExecutionError.new("No user found")
      end

    end
  end
end
