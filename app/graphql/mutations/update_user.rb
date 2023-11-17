# frozen_string_literal: true

module Mutations
    class UpdateUser < Mutations::BaseMutation
      graphql_name "UpdateUser"
  
      argument :params, Types::Input::UserUpdateInputType, required: true

      field :user, Types::UserType, null: false

      def resolve(params:)
        update_params = Hash params

        @current_user = User.find(update_params[:user_id])

        begin
            update_params.delete(:user_id)
            
            @current_user.update(update_params)

            if update_params[:gender].present?
              @current_user.male! if update_params[:gender] == 0
              @current_user.female! if update_params[:gender] == 1
            end

            if update_params[:desires_gender].present?
              @current_user.desires_men! if update_params[:desires_gender] == 0
              @current_user.desires_women! if update_params[:desires_gender] == 1
              @current_user.desires_both! if update_params[:desires_gender] == 2
            end

            { user: @current_user }
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("#{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
end