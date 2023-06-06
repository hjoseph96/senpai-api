# frozen_string_literal: true

module Mutations
    class SignIn < Mutations::BaseMutation
      graphql_name "SignIn"
  
      argument :token, String, required: true
  
      field :user, Types::UserType, null: false
  
      def resolve(args)
        @decoded = JsonWebToken.decode(header)
        @current_user = User.find(@decoded[:user_id])

        if @current_user.present?
          if @current_user.valid_password?(args[:password])
            context[:current_user] = @current_user
            MutationResult.call(obj: { user: user }, success: true)
          else
            GraphQL::ExecutionError.new("Incorrect token")
          end
        else
          GraphQL::ExecutionError.new("User not registered on this application")
        end
      end
    end
  end