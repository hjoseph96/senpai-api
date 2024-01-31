class AddJapaneseTitleToAnimes < ActiveRecord::Migration[7.1]
  def change
    add_column :animes, :japanese_title, :string
    add_index :animes, :japanese_title
  end
end
