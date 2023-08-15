module Types
    module Input
      class UserUpdateInputType < Types::BaseInputObject
        argument :user_id, ID, required: true
        argument :first_name, String, required: true
        argument :bio, String, required: true
        argument :phone, String, required: false
        argument :admin, Boolean, required: false
        argument :gender, Integer, required: true
        argument :desired_gender, Integer, required: true
        argument :verified, Boolean, required: false
        argument :school, String, required: false
        argument :occupation, String, required: false
      end
    end
end