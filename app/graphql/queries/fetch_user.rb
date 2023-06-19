module Queries
    class FetchUser < Queries::BaseQuery
      graphql_name "FetchUser"

      argument :user_id, ID, required: true
      type Types::UserType, null: false
  
      def resolve(user_id:)
        @user = User.find(user_id)

        @user
      end
    end
  end