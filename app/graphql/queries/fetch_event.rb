module Queries
  class FetchEvent < Queries::BaseQuery
    graphql_name "FetchEvent"

    argument :event_id, ID, required: true
    type Types::EventType, null: false

    def resolve(event_id:)
      @event = Event.find(event_id)
    end
  end
end