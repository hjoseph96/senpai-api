module Queries
  class FetchJoinRequests < Queries::BaseQuery
    graphql_name "FetchJoinRequests"

    argument :host_id, ID, required: true
    argument :page, Integer, required: true

    type [Types::JoinRequestType], null: false

    def resolve(host_id:, page: 1)
      @host = User.find(host_id)

      event_ids = @host.events.pluck(:id)
      results = JoinRequest.includes(:event).where(event_id: event_ids)

      results = results.order(created_at: :desc)

      results.page(page)
    end
  end
end