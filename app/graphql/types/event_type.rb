# frozen_string_literal: true

module Types
  class EventType < Types::BaseObject
    include ApplicationHelper

    field :id, ID, null: false
    field :title, String
    field :start_date, GraphQL::Types::ISO8601DateTime, null: false
    field :end_date, GraphQL::Types::ISO8601DateTime
    field :venue, String, null: false
    field :display_city, String, null: false
    field :display_state, String, null: false
    field :country, String, null: false
    field :lonlat, String, null: false
    field :description, String
    field :host_id, Integer, null: false
    field :convention_id, Integer
    field :cosplay_required, Integer
    field :payment_required, Boolean
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :party, Types::PartyType
    field :cover_image_url, String

    def party
      object.party
    end

    def cover_image_url
      cdn_for(object.cover_image)
    end
  end
end
