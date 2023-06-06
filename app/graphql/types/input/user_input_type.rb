module Types
    module Input
      class UserInputType < Types::BaseInputObject
        argument :phone, String, required: true
      end
    end
  end