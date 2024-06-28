module Types
  module Input
    class AvatarInputType < Types::BaseInputObject
      argument :guid, String, required: true
      argument :name, String, required: true
      argument :price, Integer, required: true
      argument :gender, String, required: true
      argument :is_default, Integer, required: false
      argument :photo, String, required: false
      argument :thumbnail, String, required: false
    end
  end
end