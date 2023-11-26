# frozen_string_literal: true

module Types
  class MatchType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :matchee_id, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :conversation, Types::ConversationType, null: false
    field :user, Types::UserType, null: false
    field :matchee, Types::UserType, null: false

    def conversation
      object.conversation
    end
    def user
      object.user
    end
    def matchee
      object.matchee
    end
  end
end
