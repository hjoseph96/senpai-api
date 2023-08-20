module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::CreateUser
    field :update_user, mutation: Mutations::UpdateUser
    field :sign_in, mutation: Mutations::SignIn
    field :resend_verify_text, mutation: Mutations::ResendVerifyText
    field :validate_phone, mutation: Mutations::ValidatePhone
    field :add_favorite_anime, mutation: Mutations::AddFavoriteAnime
    field :rank_favorite_anime, mutation: Mutations::RankFavoriteAnime
    field :set_spotify_email, mutation: Mutations::SetSpotifyEmail
    field :set_user_location, mutation: Mutations::SetUserLocation
    field :submit_verify_request, mutation: Mutations::SubmitVerifyRequest
    field :upload_photo, mutation: Mutations::UploadPhoto
    field :reorder_photos, mutation: Mutations::ReorderPhotos
    field :get_distance_between_users, mutation: Mutations::GetDistanceBetweenUsers
    field :like_user, mutation: Mutations::LikeUser
    field :undo_like, mutation: Mutations::UndoLike
    field :send_message, mutation: Mutations::SendMessage
    field :report_user, mutation: Mutations::ReportUser
    field :grant_user_premium, mutation: Mutations::GrantUserPremium
    field :delete_user, mutation: Mutations::DeleteUser
  end
end
