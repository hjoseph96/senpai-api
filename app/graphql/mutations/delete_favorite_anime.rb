module Mutations
  class DeleteFavoriteAnime < Mutations::BaseMutation
    argument :anime_ids, [ID], required: true

    field :deleted, Boolean, null: false
    field :user, Types::UserType

    def resolve(anime_ids:)
      unless context[:ready?]
        raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
      end

      @user = context[:current_user]
      @anime = UserAnime.where(user_id: @user.id, anime_id: anime_ids)

      { deleted: @anime.destroy_all, user: @user.reload }
    end
  end
end
