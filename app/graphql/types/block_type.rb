# frozen_string_literal: true

module Types
  class BlockType < Types::BaseObject
    field :id, ID, null: false
    field :blocker_id, ID
    field :blockee_id, ID
    field :report_id, ID
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
