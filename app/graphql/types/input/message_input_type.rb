module Types
    module Input
      class MessageInputType < Types::BaseInputObject
        argument :sender_id, Integer, required: true
        argument :content, String, required: true
      end
    end
  end