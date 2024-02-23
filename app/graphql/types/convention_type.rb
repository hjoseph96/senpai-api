# frozen_string_literal: true

module Types
  class ConventionType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :start_date, GraphQL::Types::ISO8601DateTime, null: false
    field :end_date, GraphQL::Types::ISO8601DateTime
    field :website, String
    field :lonlat, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :events, [Types::EventType]
    field :attendees, [Types::UserType]
    field :reviews, [Types::ReviewType]

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
