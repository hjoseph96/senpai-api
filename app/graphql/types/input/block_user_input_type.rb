module Types
  module Input
    class BlockUserInputType < Types::BaseInputObject
      argument :user_id, ID, required: true
      argument :blocked_user_id, ID, required: true
    end
  end
end