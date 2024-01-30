# frozen_string_literal: true

module Mutations
    class UndoLike < Mutations::BaseMutation
      graphql_name "UndoLike"

      field :status, String, null: false
      field :undid_user, Types::UserType

      def resolve(user_id:)
        unless context[:ready?]
          raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
        end

        @current_user = context[:current_user]

        @like = @current_user.likes.last
        return { status: 'failed' } unless @like.present?

        @likee = User.find(@like.likee_id)

        @match = Match.where(user_id: @current_user.id, matchee_id: @like.likee_id)
        
        @like.destroy!
        @match.destroy_all if @match.present?

        { status: 'success', undid_user: @likee }
      end
    end
end