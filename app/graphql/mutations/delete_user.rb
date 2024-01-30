module Mutations
    class DeleteUser < Mutations::BaseMutation
      field :soft_deleted_user, Types::UserType, null: false
  
      def resolve
        unless context[:ready?]
          raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
        end

        @user = context[:current_user]
        @user.destroy

        { soft_deleted_user: @user }
      end
    end
  end