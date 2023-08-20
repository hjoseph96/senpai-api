module Mutations
    class SetSpotifyEmail < Mutations::BaseMutation
      argument :user_id, Integer, required: true
      argument :email, String, required: true
  
      field :user, Types::UserType, null: false
  
      def resolve(user_id:, email:)
        @user = User.find(user_id)
 
        if @user.update(spotify_email: email)
          { user: @user }
        else
          GraphQL::ExecutionError.new("Update failed: #{@user.errors.join(', ')}")
        end
      end
    end
  end