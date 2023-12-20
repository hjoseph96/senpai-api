# frozen_string_literal: true

module Types
  class ConversationType < Types::BaseObject
    field :id, ID, null: false
    field :match_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :messages, [Types::MessageType]
    field :match, Types::MatchType
    field :last_message, Types::MessageType
    field :unread_count, Integer do
      argument :user_id, Integer
    end


    def messages
      object.messages.order(created_at: :desc)
    end

    def match
      object.match
    end

    def last_message
      object.messages.order(created_at: :desc).first
    end

    def unread_count(user_id:)
      other_persons_messages = object.messages.where.not(sender_id: user_id)
      other_persons_messages.where(read: false).count
    end
  end
end
