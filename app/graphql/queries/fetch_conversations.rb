module Queries
    class FetchConversations < Queries::BaseQuery
      graphql_name "FetchConversations"

      argument :page, Integer, required: false
      argument :search, String, required: false
      type [Types::ConversationType], null: false

      def resolve(user_id:, page: 1, search: '')
        unless context[:ready?]
          raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
        end

        @user = context[:current_user]

        convos = @user.conversations.order(created_at: :desc)
        if search.present?
          convos = convos.joins(:users).where('users.first_name ILIKE ?', search)
        end

        convos
      end
    end
  end