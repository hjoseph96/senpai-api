class SpotifyController < ApplicationController
    def callback
        response = request.env['omniauth.auth']
        spotify_user = RSpotify::User.new(response)

        # TODO: Ensure we update mobile UI
        @user = User.find_by(spotify_email: response['info']['email'])
        if @user.nil?
            render json: { error: 'user spotify_email not found' }
            return
        end

        SpotifyService.parse_music_data(user_id: @user.id, spotify_user: spotify_user)

        render json: { success: 'success' }
    end

    def test
    end
end