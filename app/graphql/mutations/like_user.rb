# frozen_string_literal: true

module Mutations
    class LikeUser < Mutations::BaseMutation
      graphql_name "LikeUser"
  
      argument :params, Types::Input::LikeInputType, required: true

      field :like, Types::LikeType, null: false

  
      def resolve(params:)
        @current_user = User.find(params[:user_id])

        begin
            @like = Like.create(user_id: @current_user.id, likee_id: params[:likee_id], like_type: params[:like_type])

            { user: @current_user, like: @like }
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
  end