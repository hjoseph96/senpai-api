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
          if params[:like_type] == 'super'
            count = @current_user.super_like_count

            if count > 0
              @current_user.update(super_like_count: count - 1)
            else
              return GraphQL::ExecutionError.new("User has no Super Likes")
            end
          end

          # 50% chance of a robot profile liking you back
          if @likee.is_fake_profile? && %w(standard super).include?(params[:like_type])
            if (1...100).to_a.sample < 50
              @like = Like.create(user_id: @likee.id, likee_id: @current_user.id, like_type: params[:like_type])
            end
          end

          @like = Like.create(user_id: @current_user.id, likee_id: params[:likee_id], like_type: params[:like_type])
          rejected = params[:like_type] == 'rejection'

          # Does the user like the other user?
          user_likes_other_user = @current_user.likes.where(likee_id: @likee.id, like_type: [:standard, :super]).count > 0

          # Does the other user like the current user?
          other_user_likes_user = @likee.likes.where(likee_id: @current_user.id, like_type: [:standard, :super]).count > 0
          
          if user_likes_other_user && other_user_likes_user && !rejected
            # Create a match for current user
            match = Match.create(user_id: @current_user.id, matchee_id: @likee.id)

            PushNotification.create(
              user_id: @current_user.id,
              event_name: 'new_match',
              content: "You've matched with #{@likee.first_name}!"
            )

            PushNotification.create(
              user_id: @likee.id,
              event_name: 'new_match',
              content: "You've matched with #{@current_user.first_name}!"
            )

            conversation = Conversation.create(match_id: match.id)
            @current_user.conversations << conversation
            @likee.conversations << conversation

            @current_user.save!
            @likee.save!
          end

          feed = Rails.cache.read("#{@current_user.id}-FEED")

          # Remove liked user from swipe feed
          if feed.present?
            feed.delete params[:likee_id]
            Rails.cache.write("#{@current_user.id}-FEED", feed)
          end

          @current_user.appear

          { like: @like, match: match }
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
end