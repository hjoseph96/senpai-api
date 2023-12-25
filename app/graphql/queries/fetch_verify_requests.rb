module Queries
  class FetchVerifyRequests < Queries::BaseQuery
    graphql_name "FetchVerifyRequests"

    argument :user_id, ID, required: true
    argument :page, Integer, required: false
    argument :per_page, Integer, required: false

    type [Types::VerifyRequestType], null: false

    def resolve(user_id:, page: 1, per_page: 50)
      @current_user = User.find(user_id)

      if @current_user.present?
        results = VerifyRequest.where(user_id: user_id).order(created_at: :desc)

        results.page(page).per(per_page)
      else
        GraphQL::ExecutionError.new("No user found")
      end

    end
  end
end
