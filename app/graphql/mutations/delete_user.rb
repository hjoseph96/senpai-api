module Mutations
    class DeleteUser < Mutations::BaseMutation
      argument :user_id, Integer, required: true
  
      field :soft_deleted_user, Types::UserType, null: false
  
      def resolve(user_id:)
        @user = User.find(user_id)

        if @user.matches.count > 0
          @user.matches.map(&:conversation).map(&:destroy)
          @user.matches.destroy_all
          @user.destroy
        end

        { soft_deleted_user: @user }
      end
    end
  end