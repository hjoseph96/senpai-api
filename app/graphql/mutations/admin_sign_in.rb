# frozen_string_literal: true

module Mutations
  class AdminSignIn < Mutations::BaseMutation
    include Devise::Controllers::Helpers

    graphql_name "AdminSignIn"

    argument :token, String, required: true

    field :user, Types::UserType, null: false

    def resolve(token:)
      @decoded = JsonWebToken.decode(token)
      @current_user = User.find(@decoded[:user_id])

      if @current_user.present? && @current_user.on_the_team?
        MutationResult.call(obj: { user: @current_user }, success: true)
      else
        GraphQL::ExecutionError.new("No admin or mod found")
      end
    end
  end
end
