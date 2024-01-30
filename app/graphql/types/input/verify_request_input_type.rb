module Types
    module Input
      class VerifyRequestInputType < Types::BaseInputObject
        argument :image, ApolloUploadServer::Upload, required: true
      end
    end
end