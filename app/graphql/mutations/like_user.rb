# frozen_string_literal: true

module Mutations
    class LikeUser < Mutations::BaseMutation
      graphql_name "LikeUser"
  
      argument :params, Types::Input::LikeInputType, required: true

      field :like, Types::LikeType, null: false
      field :match, Types::MatchType

      def resolve(params:)
        @current_user = User.find(params[:user_id])
        @likee = User.find(params[:likee_id])

        match = nil
        begin
          if params [:like_type] == 1
            count = @current_user.super_like_count

            if count > 0
              @current_user.update(super_like_count: count - 1)
            else
              return GraphQL::ExecutionError.new("User has no Super Likes")
            end
          end

          @like = Like.create(user_id: @current_user.id, likee_id: params[:likee_id], like_type: params[:like_type])
          UserLike.create(user_id: @current_user.id, like_id: @like.id)

          if @likee.likes.where(likee_id: @current_user.id, like_type: [0, 1]).count > 0
              match = Match.create(user_id: @current_user.id, matchee_id: @likee.id)
              conversation = Conversation.create(match_id: match.id)

              @current_user.conversations << conversation
              @likee.conversations << conversation

              @current_user.save!
              @likee.save!
          end

          feed = Rails.cache.read("#{@current_user.id}-FEED")
          feed.delete params[:likee_id]
          Rails.cache.write("#{@current_user.id}-FEED", feed)

          { like: @like, match: match }
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
end