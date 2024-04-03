# frozen_string_literal: true

module Types
  class BattleType < Types::BaseObject
    include ApplicationHelper

    field :id, ID, null: false
    field :blue_cornerable_type, String
    field :blue_cornerable_id, Integer
    field :red_cornerable_type, String
    field :red_cornerable_id, Integer
    field :blue_corner_votes, Integer
    field :red_corner_votes, Integer
    field :ends_at, GraphQL::Types::ISO8601DateTime
    field :voting_over, Boolean
    field :round_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :blue_corner, Types::CornerableType
    field :red_corner, Types::CornerableType
    field :winner, Types::CornerableType
    field :discord_cover, String
    field :round, Types::RoundType
    field :battle_number, Integer

    def blue_corner
      object.blue_cornerable
    end

    def red_corner
      object.red_cornerable
    end

    def winner
      object.winner
    end

    def discord_cover
      cdn_for(object.discord_cover)
    end

    def round
      object.round
    end

    def battle_number
      object.round.battles.index(object) + 1
    end
  end
end
