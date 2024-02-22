# frozen_string_literal: true

module Types
  class EventInviteType < Types::BaseObject
    field :id, ID, null: false
    field :event_id, Integer, null: false
    field :sender_id, Integer, null: false
    field :receiver_id, Integer, null: false
    field :status, String, null: false
    field :content, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :sender, Types::UserType
    field :receiver, Types::UserType
    field :event, Types::EventType


    def sender
      object.sender
    end

    def receiver
      object.receiver
    end

  end
end
