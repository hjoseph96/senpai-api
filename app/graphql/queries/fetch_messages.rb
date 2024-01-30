module Queries
  class FetchMessages < Queries::BaseQuery
    graphql_name "FetchMessages"

    argument :conversation_id, ID, required: true
    argument :page, Integer, required: false
    type [Types::MessageType], null: false

    def resolve(conversation_id:, page: 1)
      unless context[:ready?]
        raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
      end

      @convo = Conversation.find(conversation_id)

      unless @convo.present?
        return GraphQL::ExecutionError.new('Conversation with that ID not found')
      end

      @messages = Message.where(conversation_id: conversation_id)

      @messages.order(created_at: :desc).page(page).per(50)
    end
  end
end
