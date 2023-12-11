module Mutations
  class DeleteFavoriteMusic < Mutations::BaseMutation
    argument :user_id, ID, required: true
    argument :music_ids, [ID], required: true

    field :deleted, Boolean, null: false
    field :user, Types::UserType

    def resolve(user_id:, music_ids:)
      @user = User.find(user_id)
      @music = FavoriteMusic.where(user_id: user_id, id: music_ids)

      { deleted: @music.destroy_all, user: @user.reload }
    end
  end
end
