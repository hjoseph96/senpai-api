module Mutations
  class DeleteFavoriteMusic < Mutations::BaseMutation
    argument :music_ids, [ID], required: true

    field :deleted, Boolean, null: false
    field :user, Types::UserType

    def resolve(music_ids:)
      unless context[:ready?]
        raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
      end

      @user = context[:current_user]
      @music = FavoriteMusic.where(user_id: @user.id, id: music_ids)

      { deleted: @music.destroy_all, user: @user.reload }
    end
  end
end
