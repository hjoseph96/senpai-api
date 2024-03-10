module Types
  module Input
    class EventUpdateInputType < Types::BaseInputObject
      argument :user_id, ID, required: true
      argument :event_id, ID, required: true
      argument :member_limit, Integer, required: false
      argument :full_address, String, required: false
      argument :venue, String, required: false
      argument :title, String, required: false
      argument :start_date, GraphQL::Types::ISO8601DateTime, required: false
      argument :description, String, required: false
      argument :cover_image, ApolloUploadServer::Upload, required: false
      argument :end_date, GraphQL::Types::ISO8601DateTime, required: false
      argument :convention_id, Integer, required: false
      argument :cosplay_required, String, required: false
    end
  end
end