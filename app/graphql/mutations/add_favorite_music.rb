# frozen_string_literal: true

module Mutations
  class AddFavoriteMusic < Mutations::BaseMutation
    graphql_name "AddFavoriteMusic"

    argument :params, [Types::Input::FavoriteMusicInputType], required: true

    field :user, Types::UserType, null: false
    def resolve(params:)
      unless context[:ready?]
        raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
      end

      @current_user = context[:current_user]

      begin
        params.each do |p|
          attrs = {
            user_id: @current_user.id,
            music_type: p[:music_type],
            cover_url: p[:cover_url],
            spotify_id: p[:spotify_id]
          }
          attrs.merge!(track_name: p[:track_name]) if p[:track_name].present?
          attrs.merge!(artist_name: p[:artist_name]) if p[:artist_name].present?
          attrs.merge!(hidden: p[:hidden]) if p[:hidden].present?


          FavoriteMusic.create!(attrs)
        end

        { user: @current_user.reload }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end