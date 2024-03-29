module Queries
  module Discord
    class FetchCurrentBattle < Queries::BaseQuery
      graphql_name "FetchCurrentBattle"

      argument :tournament_id, ID, required: true
      type Types::BattleType, null: false

      def resolve(tournament_id:)
        tournament = Tournament.find(tournament_id)

        return GraphQL::ExecutionError.new('This tournament has been completed') if tournament.completed?

        round = tournament.rounds.where(number: tournament.current_round).first

        results = round.battles.where('ends_at > ?', DateTime.now)

        return GraphQL::ExecutionError.new('There are no active battles, proceed to next round') if results.empty?

        battle = results.first

        if battle.ends_at.nil?
          battle.update!(ends_at: DateTime.now + round.tournament.hours_duration.hours)
        end

        battle
      end
    end

  end
end