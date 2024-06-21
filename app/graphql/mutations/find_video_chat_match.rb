module Mutations
  class FindVideoChatMatch < Mutations::BaseMutation
    argument :user_id, ID, required: true

    field :user, Types::UserType

    def resolve(user_id:)
      @user = User.find(user_id)

      unless @user.present?
        return GraphQL::ExecutionError.new("No user with that ID found")
      end

      viable_matches = VideoMatchmaker.find_matches(user_id: @user.id)

      { user: viable_matches[0] }
    end
  end
end
