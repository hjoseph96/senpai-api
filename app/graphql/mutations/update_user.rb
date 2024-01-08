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

            if update_params[:first_name].present?
              update_params[:first_name] = update_params[:first_name].strip
            end
            
            @current_user.update(update_params)

            { user: @current_user.reload }
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("#{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
end