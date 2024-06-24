module Types
  module Input
    class AvatarInputType < Types::BaseInputObject
      argument :guid, String, required: true
      argument :name, String, required: true
      argument :is_default, Integer, required: false
      argument :photo, ApolloUploadServer::Upload, required: true
      argument :thumbnail, ApolloUploadServer::Upload, required: true
    end
  end
end