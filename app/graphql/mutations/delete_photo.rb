module Mutations
  class DeletePhoto < Mutations::BaseMutation
    argument :user_id, ID, required: true
    argument :photo_id, ID, required: true

    field :deleted, Boolean, null: false
    field :gallery, Types::GalleryType

    def resolve(user_id:, photo_id:)
      @user = User.find(user_id)

      @photo = @user.gallery.photos.find(photo_id)

      @user.gallery.update_photo_order!

      { deleted: @photo.destroy, gallery: @user.gallery.reload }
    end
  end
end
