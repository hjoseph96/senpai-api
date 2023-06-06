module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::CreateUser
    field :sign_in, mutation: Mutations::SignIn
    field :validate_phone, mutation: Mutations::ValidatePhone
    field :add_favorite_anime, mutation: Mutations::AddFavoriteAnime
  end
end
