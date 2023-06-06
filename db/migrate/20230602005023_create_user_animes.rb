class CreateUserAnimes < ActiveRecord::Migration[7.0]
  def change
    create_table :user_animes do |t|
      t.integer :user_id
      t.integer :anime_id

      t.timestamps
    end
    add_index :user_animes, :user_id
    add_index :user_animes, :anime_id
  end
end
