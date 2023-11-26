# frozen_string_literal: true

module Types
  class ConversationType < Types::BaseObject
    field :id, ID, null: false
    field :match_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :messages, [Types::MessageType]
    field :match, Types::MatchType

    def messages
      object.messages.order(created_at: :desc)
    end

    def match
      object.match
    end
  end
end
