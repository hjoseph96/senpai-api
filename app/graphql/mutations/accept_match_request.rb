module Mutations
  class AcceptMatchRequest < Mutations::BaseMutation
    argument :match_request_id, ID, required: true

    field :match_request, Types::MatchRequestType

    def resolve(match_request_id:)
      @match_request = MatchRequest.find(match_request_id)

      unless @match_request.present?
        return GraphQL::ExecutionError.new('Match Request cannot be found.')
      end

      @match_request.accept!

      { match_request: @match_request }
    end
  end
end
