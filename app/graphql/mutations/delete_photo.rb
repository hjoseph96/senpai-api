module Mutations
  class DeletePhoto < Mutations::BaseMutation
    argument :user_id, ID, required: true
    argument :photo_id, ID, required: true

    field :deleted, Boolean, null: false

    def resolve(user_id:, photo_id:)
      @user = User.find(user_id)

      @photo = @user.gallery.photos.find(photo_id)

      { deleted: @photo.destroy }
    end
  end
end
