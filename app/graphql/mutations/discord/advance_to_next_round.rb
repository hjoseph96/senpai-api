module Mutations
  module Discord
    class AdvanceToNextRound < Mutations::BaseMutation
      graphql_name "AdvanceToNextRound"

      argument :tournament_id, ID, required: true

      field :round, Types::RoundType, null: false
      field :winner, Types::CornerableType, null: true

      def resolve(tournament_id:)
        tournament = Tournament.find(tournament_id)

        return GraphQL::ExecutionError.new('This tournament has cannot be found') unless tournament.present?
        return GraphQL::ExecutionError.new('This tournament has been completed') if tournament.completed?

        round = tournament.rounds.where(number: tournament.current_round).first
        if round.battles.all?(&:voting_over?)
          if tournament.current_round == Math.sqrt(tournament.combatant_count.to_i)
            tournament.update!(completed: true)
            return { round: round, winner: round.battles[0].winner }
          end

          new_round = Round.create(number: round.number + 1, tournament_id: tournament_id)

          round.battles.each_slice(2) do |r1, r2|
            b = Battle.new(round_id: new_round.id, ends_at: DateTime.now + tournament.hours_duration.hours)
            b.red_cornerable = r1.winner
            b.blue_cornerable = r2.winner
            b.save!
          end

          tournament.update!(current_round: new_round.number)

          { round: new_round }
        else
          GraphQL::ExecutionError.new('Voting in all battles are not complete!')
        end
      end
    end

  end
end