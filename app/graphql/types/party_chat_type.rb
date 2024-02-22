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

    def party
      object.party
    end

    def messages
      dataloader.with(Sources::PartyMessagesByPartyChat).load(object.id)
    end
  end
end
