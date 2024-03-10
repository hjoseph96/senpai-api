module Types
  module Input
    class EventInputType < Types::BaseInputObject
      argument :user_id, ID, required: true
      argument :full_address, String, required: true
      argument :venue, String, required: true
      argument :title, String, required: true
      argument :start_date, GraphQL::Types::ISO8601DateTime, required: true
      argument :description, String, required: true
      argument :member_limit, Boolean, required: true
      argument :cover_image, ApolloUploadServer::Upload, required: false
      argument :end_date, GraphQL::Types::ISO8601DateTime, required: false
      argument :convention_id, Integer, required: false
      argument :cosplay_required, String, required: false
      argument :payment_required, Boolean, required: false
    end
  end
end