module Types
  module Input
    class BlockUserInputType < Types::BaseInputObject
      argument :blocked_user_id, ID, required: true
    end
  end
end