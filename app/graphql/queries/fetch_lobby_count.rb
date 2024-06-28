module Queries
  class FetchLobbyCount < Queries::BaseQuery
    graphql_name "FetchLobbyCount"

    type Integer, null: false

    def resolve
      User.where(awaiting_match: true).count
    end
  end
end