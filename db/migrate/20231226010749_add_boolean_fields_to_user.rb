class AddBooleanFieldsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :has_location_hidden, :boolean
    add_index :users, :has_location_hidden
    add_column :users, :has_music_hidden, :boolean
    add_index :users, :has_music_hidden
  end
end
