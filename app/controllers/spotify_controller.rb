class SpotifyController < ApplicationController
    def callback
        spotify_user = RSpotify::User.new(request.env['omniauth.auth'])

        SpotifyService.parse_music_data(user_id: 1, spotify_user: spotify_user)
    end

    def test
    end
end