# frozen_string_literal: true

module Mutations
    class SignIn < Mutations::BaseMutation
      include Devise::Controllers::Helpers

      graphql_name "SignIn"
  
      argument :token, String, required: true
  
      field :user, Types::UserType, null: false
  
      def resolve(token:)
        @decoded = JsonWebToken.decode(token)
        @current_user = User.find(@decoded[:user_id])

        if @current_user.present?
          @current_user.update_devise_fields!(context[:ip])

          MutationResult.call(obj: { user: @current_user }, success: true)
        else
          GraphQL::ExecutionError.new("User not registered on this application")
        end
      end
    end
  end