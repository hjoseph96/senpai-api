# frozen_string_literal: true

module Types
  class PartyChatType < Types::BaseObject
    field :id, ID, null: false
    field :party_id, Integer, null: false
    field :deleted_at, GraphQL::Types::ISO8601DateTime
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :party, Types::PartyType, null: false
    field :messages, [Types::PartyMessageType], null: false
    field :unread_count, Integer do
      argument :user_id, ID
    end

    def party
      object.party
    end

    def messages
      dataloader.with(Sources::PartyMessagesByPartyChat).load(object.id)
    end

    def unread_count(user_id:)
      other_persons_messages = object.messages.where.not(sender_id: user_id)
      other_persons_messages.where(read: false).count
    end
  end
end
