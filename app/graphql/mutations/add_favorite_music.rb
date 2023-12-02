# frozen_string_literal: true

module Mutations
  class AddFavoriteMusic < Mutations::BaseMutation
    graphql_name "AddFavoriteMusic"

    argument :user_id, ID, required: true
    argument :favorite_music, [Types::FavoriteMusicInputType], required: true

    field :user, Types::UserType, null: false
    def resolve(user_id:, favorite_music:)
      @current_user = User.find(user_id)

      begin
        favorite_music.each do |m|
          FavoriteMusic.create!(
            user_id: @current_user.id,
            music_type: r[:music_type],
            cover_url: r[:cover_url],
            name: r[:name]
          )
        end

        { user: @current_user.reload }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end