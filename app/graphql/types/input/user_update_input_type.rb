module Types
    module Input
      class UserUpdateInputType < Types::BaseInputObject
        argument :user_id, ID, required: true
        argument :bio, String, required: false
        argument :phone, String, required: false
        argument :admin, Boolean, required: false
        argument :gender, Integer, required: false
        argument :desired_gender, Integer, required: false
        argument :verified, Boolean, required: false
        argument :school, String, required: false
      end
    end
end