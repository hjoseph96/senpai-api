module Types
    module Input
      class MessageInputType < Types::BaseInputObject
        argument :sender_id, Integer, required: true
        argument :conversation_id, String, required: true
        argument :content, String, required: true
        argument :sticker_id, Integer, required: false
        argument :attachment, ApolloUploadServer::Upload, required: false
      end
    end
  end