# frozen_string_literal: true

module Types
  class PartyType < Types::BaseObject
    field :id, ID, null: false
    field :host_id, Integer, null: false
    field :event_id, Integer, null: false
    field :status, String, null: false
    field :disbanded, Boolean, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :members, [Types::UserType]
    field :party_chat, Types::PartyChatType
    field :messages, [Types::PartyMessageType]

    def members
      dataloader.with(Sources::MembersByPartyId).load(object.id)
    end

    def party_chat
      object.party_chat
    end

    def messages
      object.party_chat.messages
    end
  end
end
