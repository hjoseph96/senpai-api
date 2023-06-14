module Types
    module Input
      class VerifyRequestInputType < Types::BaseInputObject
        argument :user_id, Integer, required: true
        argument :image, ApolloUploadServer::Upload, required: true
      end
    end
end