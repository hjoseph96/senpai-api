module Mutations
  class DeleteFavoriteAnime < Mutations::BaseMutation
    argument :user_id, ID, required: true
    argument :anime_ids, [ID], required: true

    field :deleted, Boolean, null: false
    field :user, Types::UserType

    def resolve(user_id:, anime_ids:)
      @user = User.find(user_id)
      @anime = UserAnime.where(user_id: user_id, anime_id: anime_ids)

      { deleted: @anime.destroy_all, user: @user.reload }
    end
  end
end
