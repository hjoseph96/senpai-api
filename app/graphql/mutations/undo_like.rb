# frozen_string_literal: true

module Mutations
    class UndoLike < Mutations::BaseMutation
      graphql_name "UndoLike"
  
      argument :user_id, ID, required: true

      field :status, String, null: false
      field :undid_user, Types::UserType

      def resolve(user_id:)
        @current_user = User.find(user_id)

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