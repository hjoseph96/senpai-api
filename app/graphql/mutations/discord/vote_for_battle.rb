# frozen_string_literal: true

module Mutations
  module Discord
    class VoteForBattle < Mutations::BaseMutation
      graphql_name "VoteForBattle"

      argument :battle_id, ID, required: true
      argument :battle_vote, String, required: true

      field :battle, Types::BattleType, null: false

      def resolve(battle_id:, battle_vote:)
        battle = Battle.find(battle_id)

        return GraphQL::ExecutionError.new('No battle with that id') unless battle.present?

        if battle.ends_at < DateTime.now
          return GraphQL::ExecutionError.new('Voting for this battle has been completed')
        end

        case battle_vote
        when 'red' then battle.update(red_corner_votes: battle.red_corner_votes + 1)
        when 'blue' then battle.update(blue_corner_votes: battle.blue_corner_votes + 1)
        else
          return GraphQL::ExecutionError.new('Invalid battle_vote given, must be red or blue.')
        end

        { battle: battle }
      end
    end
  end
end