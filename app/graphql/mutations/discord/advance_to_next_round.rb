module Mutations
  module Discord
    class AdvanceToNextRound < Mutations::BaseMutation
      include ApplicationHelper

      graphql_name "AdvanceToNextRound"

      argument :tournament_id, ID, required: true

      field :round, Types::RoundType, null: false
      field :winner_image_url, String, null: true

      def resolve(tournament_id:)
        tournament = Tournament.find(tournament_id)

        return GraphQL::ExecutionError.new('This tournament has cannot be found') unless tournament.present?

        round = tournament.rounds.where(number: tournament.current_round).first
        if round.battles.all?(&:voting_over?)

          if tournament.current_round == Math.sqrt(tournament.combatant_count.to_i)
            tournament.update!(completed: true)
            tournament.generate_winner_image

            return { round: round, winner_image_url: cdn_for(tournament.winner_image) }
          end

          new_round = Round.create(number: round.number + 1, tournament_id: tournament_id)

          round.battles.each_slice(2).with_index do |(r1, r2), i|
            b = Battle.new(round_id: new_round.id, ends_at: DateTime.now + tournament.hours_duration.hours)

            b.red_cornerable = r1.winner
            b.blue_cornerable = r2.winner
            b.battle_index = i + 1
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