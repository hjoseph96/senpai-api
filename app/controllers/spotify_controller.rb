class SpotifyController < ApplicationController
    def callback
        user_id = Rails.cache.read('user_id')
        spotify_user = RSpotify::User.new(request.env['omniauth.auth'])

        SpotifyService.parse_music_data(user_id: user_id, spotify_user: spotify_user)

        render json: { success: 'success' }
    end

    def test
    end
end