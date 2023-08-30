module Types
    module Input
      class MessageInputType < Types::BaseInputObject
        argument :sender_id, Integer, required: true
        argument :conversation_id, String, required: true
        argument :content, String, required: true
        argument :sticker_id, ID, required: false
        argument :attachment, ApolloUploadServer::Upload, required: false
        argument :recommended_anime_id, ID, required: false
      end
    end
  end