# frozen_string_literal: true

module Mutations
    class GrantUserPremium < Mutations::BaseMutation
      graphql_name "GrantUserPremium"
  
      argument :user_id, Integer, required: true

      field :user, Types::UserType, null: false

      def resolve(user_id:)
        @current_user = User.find(user_id)

        begin
            @current_user.update!(premium: true, next_payment_date: Date.today + 1.month)

            { user: @current_user.reload }
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
end