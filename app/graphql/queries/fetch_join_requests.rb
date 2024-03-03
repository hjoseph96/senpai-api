module Queries
  class FetchJoinRequests < Queries::BaseQuery
    graphql_name "FetchJoinRequests"

    argument :event_id, ID, required: true
    argument :page, Integer, required: false

    type [Types::JoinRequestType], null: false

    def resolve(event_id:, page: 1)
      results = JoinRequest.includes(:event).where(events: { id: event_id })

      results = results.order(created_at: :desc)

      results.page(page)
    end
  end
end