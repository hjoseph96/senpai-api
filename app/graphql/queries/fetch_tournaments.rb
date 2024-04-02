module Queries
  class FetchTournaments < Queries::BaseQuery
    graphql_name "FetchStickers"

    argument :page, Integer, required: false
    argument :tournament_type, String, required: false
    type [Types::TournamentType], null: false

    def resolve(page:)
      p = page || 1

      Tournament.where(completed: false).order(created_at: :desc).page(p).per(30)
    end
  end
end