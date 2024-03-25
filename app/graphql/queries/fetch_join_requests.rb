module Queries
  class FetchJoinRequests < Queries::BaseQuery
    graphql_name "FetchJoinRequests"

    argument :event_id, ID, required: true
    argument :applicant_id, ID, required: false
    argument :page, Integer, required: false

    type [Types::JoinRequestType], null: false

    def resolve(event_id:, page: 1, applicant_id: nil)
      results = JoinRequest.includes(:event).where(events: { id: event_id }).where(status: :pending)

      results = results.order(created_at: :desc)

      unless applicant_id.nil?
        results = results.where(user_id: applicant_id)
      end

      results.page(page)
    end
  end
end