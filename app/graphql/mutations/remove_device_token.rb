# frozen_string_literal: true

module Mutations
  class RemoveDeviceToken < Mutations::BaseMutation
    graphql_name "RemoveDeviceToken"

    argument :user_id, ID, required: true
    argument :device_token, String, required: true

    field :user, Types::UserType, null: false

    def resolve(user_id:, device_token:)
      @current_user = User.find(user_id)

      unless @current_user.present?
        return GraphQL::ExecutionError.new("User not found")
      end

      unless @current_user.device_infos.where(token: device_token).count > 0
        return GraphQL::ExecutionError.new("Token not found")
      end

      begin
        device_info = DeviceInfo.where(
          user_id: @current_user.id,
          token: device_token
        )

        device_info.destroy_all

        { user: @current_user }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end