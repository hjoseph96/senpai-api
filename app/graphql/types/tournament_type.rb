# frozen_string_literal: true

module Types
  class TournamentType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :tournament_type, Integer, null: false
    field :user_id, Integer
    field :hours_duration, Integer
    field :combatant_count, Integer
    field :completed, Boolean
    field :current_round, Integer

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :rounds, [Types::RoundType]

    def rounds
      object.rounds
    end
  end
end
