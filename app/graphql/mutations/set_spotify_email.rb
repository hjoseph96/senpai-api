module Mutations
    class SetSpotifyEmail < Mutations::BaseMutation
      argument :user_id, Integer, required: true
      argument :email, String, required: true
  
      field :updated, Boolean, null: false
  
      def resolve(user_id:, email:)
        @user = User.find(user_id)
 
        { updated: @user.update(spotify_email: email) }
      end
    end
  end