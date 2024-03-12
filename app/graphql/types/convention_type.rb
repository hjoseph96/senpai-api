# frozen_string_literal: true

module Types
  class ConventionType < Types::BaseObject
    include ApplicationHelper

    field :id, ID, null: false
    field :title, String, null: false
    field :start_date, GraphQL::Types::ISO8601DateTime, null: false
    field :end_date, GraphQL::Types::ISO8601DateTime
    field :website, String
    field :display_city, String
    field :display_state, String
    field :country, String
    field :full_address, String, null: false
    field :lonlat, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :cover_image_url, String
    field :events, [Types::EventType]
    field :attendees, [Types::UserType]
    field :reviews, [Types::ReviewType]

    def cover_image_url
      cdn_for(object.cover_image)
    end

    def events
      object.events
    end

    def attendees
      object.attendees
    end

    def reviews
      object.reviews
    end
  end
end
