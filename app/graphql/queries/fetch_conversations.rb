module Queries
    class FetchConversations < Queries::BaseQuery
      graphql_name "FetchConversations"

      argument :user_id, Types::Input::AnimeInputType, required: true
      type [Types::ConversationType], null: false
  
      def resolve(user_id:)
        @user =  User.find(user_id)

        { results: @user.conversations }
      end
    end
  end