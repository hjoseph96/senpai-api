# frozen_string_literal: true

module Mutations
    class AddFavoriteAnime < Mutations::BaseMutation
      graphql_name "AddFavoriteAnime"
  
      argument :user_id, ID, required: true
      argument :anime_ids, [ID], required: true
  
      field :user, Types::UserType, null: false
  
      def resolve(user_id:, anime_ids:)
        @current_user = User.find(user_id)

        begin
            @animes = Anime.where(id: anime_ids)
            @current_user.animes << @animes

            @current_user.save

            { user: @current_user }
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
  end