module Mutations
  class AddSuperLikes < Mutations::BaseMutation
    argument :user_id, ID, required: true
    argument :amount, Integer, required: true
    field :user, Types::UserType

    def resolve(user_id:, amount: )
      @user = User.find(user_id)

      @user.update(super_like_count: @user.super_like_count + amount)

      { user: @user.reload }
    end
  end
end
