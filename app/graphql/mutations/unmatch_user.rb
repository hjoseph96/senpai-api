module Mutations
  class UnmatchUser < Mutations::BaseMutation
    argument :params, Types::Input::BlockUserInputType, required: true

    field :user, Types::UserType, null: false

    def resolve(params:)
      block_params = Hash params

      begin
        user = User.find(block_params[:user_id])

        # Unmatch blocked user
        user.matches.where(matchee_id: block_params[:blocked_user_id]).destroy_all

        Block.create!(
          blocker_id: block_params[:user_id],
          blockee_id: block_params[:blocked_user_id]
        )

        user
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("#{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end