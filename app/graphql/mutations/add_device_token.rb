# frozen_string_literal: true

module Mutations
  class AddDeviceToken < Mutations::BaseMutation
    graphql_name "AddDeviceToken"

    argument :user_id, ID, required: true
    argument :device_token, String, required: true

    field :user, Types::UserType, null: false

    def resolve(user_id:, device_token:)
      @current_user = User.find(user_id)

      unless @current_user.present?
        return GraphQL::ExecutionError.new("User not found")
      end

      begin
        @current_user.device_tokens << device_token
        @current_user.save!

        { user: @current_user }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end