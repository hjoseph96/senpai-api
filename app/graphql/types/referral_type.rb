# frozen_string_literal: true

module Types
  class ReferralType < Types::BaseObject
    field :id, ID, null: false
    field :referer_id, Integer
    field :referred_id, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def referer
      object.referer
    end

    def referee
      object.referee
    end
  end
end
