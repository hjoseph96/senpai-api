module Mutations
    class DeleteUser < Mutations::BaseMutation
      argument :user_id, Integer, required: true
  
      field :soft_deleted, Boolean, null: false
  
      def resolve(user_id:)
        @user = User.find(user_id)

        { soft_deleted: @user.destroy }
      end
    end
  end