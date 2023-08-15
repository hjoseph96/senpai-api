module Types
    module Input
      class MessageInputType < Types::BaseInputObject
        argument :sender_id, Integer, required: true
        argument :conversation_id, String, required: true
        argument :content, String, required: true
        argument :match_id, Integer, required: true
        argument :attachment, ApolloUploadServer::Upload, required: false
      end
    end
  end