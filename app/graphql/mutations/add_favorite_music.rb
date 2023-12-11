# frozen_string_literal: true

module Mutations
  class AddFavoriteMusic < Mutations::BaseMutation
    graphql_name "AddFavoriteMusic"

    argument :params, [Types::Input::FavoriteMusicInputType], required: true

    field :user, Types::UserType, null: false
    def resolve(params:)
      @current_user = User.find(params[0][:user_id])

      begin
        params.each do |p|
          FavoriteMusic.create!(
            user_id: @current_user.id,
            music_type: p[:music_type],
            cover_url: p[:cover_url],
            name: p[:name]
          )
        end

        { user: @current_user.reload }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end