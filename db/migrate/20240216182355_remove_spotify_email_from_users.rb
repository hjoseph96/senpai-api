class RemoveSpotifyEmailFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :spotify_email, :string
  end
end
