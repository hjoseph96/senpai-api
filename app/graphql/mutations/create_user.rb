module Mutations
    class CreateUser < Mutations::BaseMutation
      argument :params, Types::Input::UserInputType, required: true
  
      field :user, Types::UserType, null: false
  
      def resolve(params:)
        user_params = Hash params
  
        begin
          user = User.create!(user_params)
  
          token = JsonWebToken.encode(user_id: @user.id)
          { user: user, token: token }
        rescue ActiveRecord::RecordInvalid => e
          GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
  end