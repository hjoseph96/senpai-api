# frozen_string_literal: true

module Types
  class MatchRequestType < Types::BaseObject
    field :id, ID, null: false
    field :sender_id, Integer, null: false
    field :receiver_id, Integer, null: false
    field :status, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
