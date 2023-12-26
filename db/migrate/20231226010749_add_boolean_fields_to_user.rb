class AddBooleanFieldsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :has_location_hidden, :boolean
    add_index :users, :has_location_hidden
    add_column :favorite_musics, :hidden, :boolean
    add_index :favorite_musics, :hidden
  end
end
