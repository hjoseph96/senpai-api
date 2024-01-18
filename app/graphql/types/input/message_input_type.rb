module Types
    module Input
      class MessageInputType < Types::BaseInputObject
        argument :sender_id, Integer, required: true
        argument :conversation_id, String, required: true
        argument :content, String, required: false
        argument :sticker_id, ID, required: false
        argument :attachment, ApolloUploadServer::Upload, required: false
        argument :attachment_type, String, required: false
        argument :recommended_anime_id, ID, required: false
      end
    end
  end