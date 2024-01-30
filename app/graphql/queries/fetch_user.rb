module Queries
    class FetchUser < Queries::BaseQuery
      graphql_name "FetchUser"

      argument :user_id, ID, required: true
      type Types::UserType, null: false
  
      def resolve(user_id:)
        unless context[:ready?]
          raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
        end

        @user = User.find(user_id)

        @user
      end
    end
  end