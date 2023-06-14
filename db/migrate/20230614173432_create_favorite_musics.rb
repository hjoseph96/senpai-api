class CreateFavoriteMusics < ActiveRecord::Migration[7.0]
  def change
    create_table :favorite_musics do |t|
      t.integer :music_type
      t.string :cover_url
      t.string :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :favorite_musics, :music_type
    add_index :favorite_musics, :name
  end
end
