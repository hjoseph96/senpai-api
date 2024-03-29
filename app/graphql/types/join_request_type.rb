# frozen_string_literal: true

module Types
  class JoinRequestType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :event_id, Integer, null: false
    field :conversation_id, String
    field :status, String, null: false
    field :description, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :applicant, Types::UserType
    field :event, Types::EventType
    field :conversation, Types::ConversationType

    def applicant
      object.user
    end

    def event
      object.event
    end

    def conversation
      object.conversation
    end
  end
end
