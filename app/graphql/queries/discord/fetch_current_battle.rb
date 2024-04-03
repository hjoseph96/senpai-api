module Queries
  module Discord
    class FetchCurrentBattle < Queries::BaseQuery
      graphql_name "FetchCurrentBattle"

      argument :tournament_id, ID, required: true
      type Types::BattleType, null: false

      def resolve(tournament_id:)
        tournament = Tournament.where(id: tournament_id).try(:first)

        return GraphQL::ExecutionError.new('No tournament with that id was found') unless tournament.present?
        return GraphQL::ExecutionError.new('This tournament has been completed') if tournament.completed?

        tournament.update(current_round: 1) unless tournament.current_round.present?
        round = tournament.rounds.where(number: tournament.current_round).first

        results = round.battles.order(created_at: :desc).where('ends_at > ?', DateTime.now)

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