module Types
  module Input
    class MessageUpdateInputType < Types::BaseInputObject
      argument :message_id, ID, required: true
      argument :content, String, required: false
      argument :reaction, String, required: false
    end
  end
end