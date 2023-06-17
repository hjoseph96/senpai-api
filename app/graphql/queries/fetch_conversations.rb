module Queries
    class FetchConversations < Queries::BaseQuery
      graphql_name "FetchConversations"

      argument :user_id, ID, required: true
      type [Types::ConversationType], null: false
  
      def resolve(user_id:)
        @user =  User.find(user_id)

        @user.conversations
      end
    end
  end