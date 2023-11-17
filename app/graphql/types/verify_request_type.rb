# frozen_string_literal: true

module Types
  class VerifyRequestType < Types::BaseObject
    include ApplicationHelper

    field :id, ID, null: false
    field :status, String, null: false
    field :user_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :user, Types::UserType, null: false
    field :url, String, null: false

    def user
      object.user
    end

    def url
      cdn_for(object.submitted_photo)
    end
  end
end
