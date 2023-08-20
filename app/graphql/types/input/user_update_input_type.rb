module Types
    module Input
      class UserUpdateInputType < Types::BaseInputObject
        argument :user_id, ID, required: true
        argument :first_name, String, required: false
        argument :birthday, GraphQL::Types::ISO8601DateTime, required: false
        argument :bio, String, required: true
        argument :phone, String, required: false
        argument :gender, Integer, required: false
        argument :desired_gender, Integer, required: false
        argument :verified, Boolean, required: false
        argument :school, String, required: false
        argument :occupation, String, required: false
      end
    end
end