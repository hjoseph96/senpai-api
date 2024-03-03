# frozen_string_literal: true

module Mutations
  class AddDeviceToken < Mutations::BaseMutation
    graphql_name "AddDeviceToken"

    argument :user_id, ID, required: true
    argument :device_type, String, required: true
    argument :device_token, String, required: true

    field :device_info, Types::DeviceInfoType, null: false

    def resolve(user_id:, device_token:, device_type:)
      @current_user = User.find(user_id)

      unless @current_user.present?
        return GraphQL::ExecutionError.new("User not found")
      end

      unless %w[ios android].include?(device_type)
        return GraphQL::ExecutionError.new("Invalid device_type")
      end

      unless @current_user.device_infos.where(token: device_token).count == 0
        return GraphQL::ExecutionError.new("Token already exists")
      end

      begin
        device_info = DeviceInfo.create!(
          user_id: @current_user.id,
          device_type: device_type,
          token: device_token
        )

        { device_info: device_info }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end