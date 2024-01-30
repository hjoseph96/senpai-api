module Mutations
  class DeletePhoto < Mutations::BaseMutation
    argument :photo_id, ID, required: true

    field :deleted, Boolean, null: false
    field :gallery, Types::GalleryType

    def resolve(photo_id:)
      unless context[:ready?]
        raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
      end

      @user = context[:current_user]

      @photo = @user.gallery.photos.find(photo_id)

      @user.gallery.update_photo_order!

      { deleted: @photo.destroy, gallery: @user.gallery.reload }
    end
  end
end
