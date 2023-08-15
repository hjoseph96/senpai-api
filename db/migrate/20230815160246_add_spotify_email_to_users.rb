class AddSpotifyEmailToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :spotify_email, :string
    add_index :users, :spotify_email
  end
end
