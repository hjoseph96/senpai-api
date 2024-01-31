# frozen_string_literal: true

module Mutations
  class AddSuperLikes < Mutations::BaseMutation
    graphql_name "AddSuperLikes"

    argument :user_id, ID, required: true
    argument :amount, Integer, required: true

    field :user, Types::UserType, null: false

    def resolve(user_id:, amount:)
      @current_user = User.find(user_id)

      unless @current_user.present?
        return GraphQL::ExecutionError.new("User not found")
      end

      begin
        current_count = @current_user.super_like_count.nil? ? 0 : @current_user.super_like_count
        @current_user.update(
          super_like_count: current_count + amount
        )

        { user: @current_user }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end