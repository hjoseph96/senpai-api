class SpotifyService
    def self.parse_music_data(user_id:, spotify_user:)
        new.parse_music_data(user_id: user_id, spotify_user: spotify_user)
    end

    def parse_music_data(user_id:, spotify_user:)
        @user = User.find(user_id)

        parse_top_tracks(spotify_user)
        parse_top_artists(spotify_user)
    end

    def parse_top_artists(spotify_user)
        top_artists = spotify_user.top_artists

        return if top_artists.empty?

        top_artists.each do |artist|
            image_url = artist.images[0]['url']

            FavoriteMusic.create!(user_id: @user.id, music_type: :artist, cover_url: image_url, name: artist.name)
        end
    end

    def parse_top_tracks(spotify_user)
        top_tracks = spotify_user.top_tracks

        return if top_tracks.empty?

        top_tracks.each do |song|
            image_url = song.album.images[0]['url']

            FavoriteMusic.create!(user_id: @user.id, music_type: :track, cover_url: image_url, name: song.name)
        end        
    end

end