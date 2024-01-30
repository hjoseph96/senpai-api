module Types
    module Input
      class UserUpdateInputType < Types::BaseInputObject
        argument :first_name, String, required: false
        argument :birthday, GraphQL::Types::ISO8601DateTime, required: false
        argument :bio, String, required: false
        argument :phone, String, required: false
        argument :gender, Integer, required: false
        argument :desired_gender, Integer, required: false
        argument :verified, Boolean, required: false
        argument :school, String, required: false
        argument :occupation, String, required: false
        argument :has_location_hidden, Boolean, required: false
        argument :super_like_count, Integer, required: false

      end
    end
end