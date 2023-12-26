# frozen_string_literal: true

module Mutations
  class UpdateFavoriteMusic < Mutations::BaseMutation
    graphql_name "UpdateFavoriteMusic"

    argument :params, [Types::Input::FavoriteMusicUpdateType], required: true

    field :user, Types::UserType, null: false
    def resolve(params:)
      @current_user = User.find(params[0][:user_id])

      begin
        params.each do |p|
          m = @current_user.favorite_music.where(id: p[:favorite_music_id])[0]

          attrs = {
            music_type: p[:music_type],
            cover_url: p[:cover_url],
            spotify_id: p[:spotify_id]
          }
          attrs.merge!(track_name: p[:track_name]) if p[:track_name].present?
          attrs.merge!(artist_name: p[:artist_name]) if p[:artist_name].present?
          attrs.merge!(hidden: p[:hidden]) if p[:hidden].present?

          m.update(attrs)
        end

        { user: @current_user.reload }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end