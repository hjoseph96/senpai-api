module Queries
  class FetchMatchRequest < Queries::BaseQuery
    graphql_name "FetchMatchRequest"

    argument :match_request_id, ID, required: true
    type Types::MatchRequestType, null: false

    def resolve(event_id:)
      @match_request = MatchRequest.find(event_id)
    end
  end
end