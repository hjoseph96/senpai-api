module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::CreateUser
    field :update_user, mutation: Mutations::UpdateUser
    field :sign_in, mutation: Mutations::SignIn
    field :resend_verify_text, mutation: Mutations::ResendVerifyText
    field :validate_phone, mutation: Mutations::ValidatePhone
    field :add_favorite_anime, mutation: Mutations::AddFavoriteAnime
    field :delete_favorite_anime, mutation: Mutations::DeleteFavoriteAnime
    field :rank_favorite_anime, mutation: Mutations::RankFavoriteAnime
    field :add_favorite_music, mutation: Mutations::AddFavoriteMusic
    field :update_favorite_music, mutation: Mutations::UpdateFavoriteMusic
    field :delete_favorite_music, mutation: Mutations::DeleteFavoriteMusic
    field :set_user_location, mutation: Mutations::SetUserLocation
    field :submit_verify_request, mutation: Mutations::SubmitVerifyRequest
    field :upload_photo, mutation: Mutations::UploadPhoto
    field :reorder_photos, mutation: Mutations::ReorderPhotos
    field :get_distance_between_users, mutation: Mutations::GetDistanceBetweenUsers
    field :like_user, mutation: Mutations::LikeUser
    field :undo_like, mutation: Mutations::UndoLike
    field :add_device_token, mutation: Mutations::AddDeviceToken
    field :remove_device_token, mutation: Mutations::RemoveDeviceToken
    field :send_message, mutation: Mutations::SendMessage
    field :update_message, mutation: Mutations::UpdateMessage
    field :report_user, mutation: Mutations::ReportUser
    field :unmatch_user, mutation: Mutations::UnmatchUser
    field :grant_user_premium, mutation: Mutations::GrantUserPremium
    field :add_super_likes, mutation: Mutations::AddSuperLikes
    field :delete_user, mutation: Mutations::DeleteUser
    field :delete_photo, mutation: Mutations::DeletePhoto
    field :create_event, mutation: Mutations::CreateEvent
  end
end
