# frozen_string_literal: true

module Types
  class TournamentType < Types::BaseObject
    include ApplicationHelper

    field :id, ID, null: false
    field :title, String, null: false
    field :tournament_type, String, null: false
    field :user_id, Integer
    field :hours_duration, Integer
    field :combatant_count, Integer
    field :completed, Boolean
    field :current_round, Integer

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :rounds, [Types::RoundType]
    field :winner_image_url, String

    def rounds
      object.rounds
    end

    def winner_image_url
      cdn_for(object.winner_image)
    end
  end
end
