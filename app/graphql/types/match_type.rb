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
      dataloader.with(Sources::ConversationByMatchId).load(object.id)
    end

    def user
      dataloader.with(Sources::UserByMatchId).load(object.id)
    end

    def matchee
      dataloader.with(Sources::MatcheeByMatchId).load(object.id)
    end
  end
end
