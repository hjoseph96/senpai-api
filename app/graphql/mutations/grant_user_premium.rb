# frozen_string_literal: true

module Mutations
    class GrantUserPremium < Mutations::BaseMutation
      graphql_name "GrantUserPremium"

      field :user, Types::UserType, null: false

      def resolve(user_id:)
        unless context[:ready?]
          raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
        end

        @current_user = context[:current_user]

        begin
            @current_user.update!(premium: true)

            { user: @current_user }
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
end