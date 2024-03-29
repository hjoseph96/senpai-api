# frozen_string_literal: true

module Types
  class RoundType < Types::BaseObject
    field :id, ID, null: false
    field :number, Integer
    field :tournament_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :battles, [Types::BattleType]
  end
end
