module Mutations
  class DeleteFavoriteAnime < Mutations::BaseMutation
    argument :user_id, ID, required: true
    argument :anime_id, ID, required: true

    field :deleted, Boolean, null: false
    field :user, Types::UserType

    def resolve(user_id:, anime_id:)
      @anime = UserAnime.find_by(user_id: user_id, anime_id: anime_id)

      { deleted: @anime.destroy, gallery: @user.reload }
    end
  end
end
