# frozen_string_literal: true

module Mutations
  class GrantUserAvatar < Mutations::BaseMutation
    graphql_name "GrantUserAvatar"

    argument :user_id, Integer, required: true
    argument :avatar_id, Integer, required: true

    field :avatar, Types::AvatarType, null: false

    def resolve(user_id:, avatar_id:)
      @current_user = User.find(user_id)
      @avatar = Avatar.find(avatar_id)

      begin
        @avatar.clone!(user_id)

        { avatar: @avatar.reload }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end