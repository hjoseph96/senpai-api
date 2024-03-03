module Types
  module Input
    class JoinRequestInputType < Types::BaseInputObject
      argument :user_id, ID, required: true
      argument :event_id, ID, required: true
      argument :join_request_id, ID, required: false
      argument :description, String, required: false
      argument :status, String, required: false
    end
  end
end