module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::CreateUser
    field :sign_in, mutation: Mutations::SignIn
    field :validate_phone, mutation: Mutations::ValidatePhone
    field :add_favorite_anime, mutation: Mutations::AddFavoriteAnime
    field :upload_photo, mutation: Mutations::UploadPhoto
    field :like_user, mutation: Mutations::LikeUser
    field :send_message, mutation: Mutations::SendMessage
    field :submit_verify_request, mutation: Mutations::SubmitVerifyRequest
  end
end
