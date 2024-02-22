module Types
  module Input
    class EventInviteInputType < Types::BaseInputObject
      argument :sender_id, ID, required: true
      argument :receiver_id, ID, required: true
      argument :event_id, ID, required: true
      argument :content, String, required: false
    end
  end
end