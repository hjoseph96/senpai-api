# frozen_string_literal: true

module Types
  class ReviewType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :score, Float, null: false
    field :review_type, String, null: false
    field :reviewable_type, String, null: false
    field :reviewable_id, Integer, null: false
    field :feedback, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :source, Types::ReviewableType

    def source
      object.reviewable
    end
  end
end
