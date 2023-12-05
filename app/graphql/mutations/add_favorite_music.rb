# frozen_string_literal: true

module Mutations
  class AddFavoriteMusic < Mutations::BaseMutation
    graphql_name "AddFavoriteMusic"

    argument :params, [Types::Input::FavoriteMusicInputType], required: true

    field :user, Types::UserType, null: false
    def resolve(params:)
      music_params = Hash params
      @current_user = User.find(music_params[0][:user_id])

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