module Queries
    class FetchConversations < Queries::BaseQuery
      graphql_name "FetchConversations"

      argument :user_id, ID, required: true
      argument :page, Integer, required: false
      type [Types::ConversationType], null: false
  
      def resolve(user_id:, page: 1)
        begin
          @user = User.find(user_id)
        rescue ActiveRecord::RecordNotFound
          return GraphQL::ExecutionError.new('User with that ID not found')
        end

        @user.conversations.order(created_at: :desc).page(page).per(10)
      end
    end
  end