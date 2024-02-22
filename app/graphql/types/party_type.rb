# frozen_string_literal: true

module Types
  class PartyType < Types::BaseObject
    field :id, ID, null: false
    field :host_id, Integer, null: false
    field :event_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :members, [Types::UserType]

    def members
      dataloader.with(Sources::MembersByPartyId).load(object.id)
    end
  end
end
