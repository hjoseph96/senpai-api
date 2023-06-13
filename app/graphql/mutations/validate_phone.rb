module Mutations
    class ValidatePhone < Mutations::BaseMutation
      argument :code, Integer
      argument :user_id, ID
  
      field :user, Types::UserType, null: false
  
      def resolve(params:)
        begin
          user = User.find(params[:user_id])

          if user.valid_password?(params[:code])
            token = JsonWebToken.encode(user_id: user.id)
            { user: user, token: token }
          else
            GraphQL::ExecutionError.new("Invalid tokren")
          end
        rescue ActiveRecord::RecordInvalid => e
          GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
  end