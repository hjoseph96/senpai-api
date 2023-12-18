class AddSpotifyIdToFavoriteMusic < ActiveRecord::Migration[7.0]
  def change
    add_column :favorite_musics, :spotify_id, :string
  end
end
