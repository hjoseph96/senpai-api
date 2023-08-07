# frozen_string_literal: true

module Mutations
    class RankFavoriteAnime < Mutations::BaseMutation
      graphql_name "RankFavoriteAnime"
  
      argument :user_id, ID, required: true
      argument :anime_ids, [ID], required: true
  
      field :user, Types::UserType, null: false
  
      def resolve(user_id:, anime_ids:)
        @current_user = User.find(user_id)

        begin
            anime_ids.each_with_index { |id, rank| UserAnime.where(anime_id: id).update(order: rank) }

            { user: @current_user }
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
  end