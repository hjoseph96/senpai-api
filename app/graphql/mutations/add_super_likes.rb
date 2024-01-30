# frozen_string_literal: true

module Mutations
  class AddSuperLikes < Mutations::BaseMutation
    graphql_name "AddSuperLikes"

    argument :amount, Integer, required: true

    field :user, Types::UserType, null: false

    def resolve(amount:)
      unless context[:ready?]
        raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
      end

      @current_user = context[:current_user]

      unless @current_user.present?
        return GraphQL::ExecutionError.new("User not found")
      end

      begin
        @current_user.update(
          super_like_count: @current_user.super_like_count + amount
        )

        { user: @current_user }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end