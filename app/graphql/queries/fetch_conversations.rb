module Queries
    class FetchConversations < Queries::BaseQuery
      graphql_name "FetchConversations"

      argument :user_id, ID, required: true
      argument :page, Integer, required: false
      argument :search, String, required: false
      type [Types::ConversationType], null: false

      def resolve(user_id:, page: 1, search: '')
        begin
          @user = User.find(user_id)
        rescue ActiveRecord::RecordNotFound
          return GraphQL::ExecutionError.new('User with that ID not found')
        end

        convos = @user.conversations.order(created_at: :desc)
        if search.present?
          convos = convos.joins(:users).where('users.first_name ILIKE ?', search)
        end

        convos
      end
    end
  end