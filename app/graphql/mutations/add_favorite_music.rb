# frozen_string_literal: true

module Mutations
  class AddFavoriteMusic < Mutations::BaseMutation
    graphql_name "AddFavoriteMusic"

    argument :params, [Types::Input::FavoriteMusicInputType], required: true

    field :user, Types::UserType, null: false
    def resolve(params:)
      @current_user = User.find(params[:user_id])

      begin
        FavoriteMusic.create!(
          user_id: @current_user.id,
          music_type: params[:music_type],
          cover_url: params[:cover_url],
          name: params[:name]
        )

        { user: @current_user.reload }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end