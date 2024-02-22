module Types
  module Input
    class SearchEventInputType < Types::BaseInputObject
      argument :user_id, ID, required: false
      argument :query, String, required: false
      argument :miles_away, Integer, required: false
      argument :start_date, GraphQL::Types::ISO8601DateTime, required: true
      argument :end_date, GraphQL::Types::ISO8601DateTime, required: false
      argument :page, Integer, required: false
    end
  end
end