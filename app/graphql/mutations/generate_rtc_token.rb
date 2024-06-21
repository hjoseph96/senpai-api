# frozen_string_literal: true

module Mutations
  class GenerateRtcToken < Mutations::BaseMutation
    argument :params, Types::Input::RtcTokenInputType, required: true

    field :token, String, null: false

    def resolve(params:)
      @user = User.where(id: params[:user_id])

      if @user.empty?
        unless params[:is_testing] && params[:user_id].to_i == 0
          return GraphQL::ExecutionError.new("No user with that ID found")
        end
      end

      @token = ''
      if params[:is_testing]
        @token = AgoraService.generate_rtc_token('Test', params[:user_id])
      else
        @token = AgoraService.generate_rtc_token(params[:channel_name], params[:user_id] )
      end

      { token: @token }
    end
  end
end
