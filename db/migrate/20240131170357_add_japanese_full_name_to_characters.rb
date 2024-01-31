class AddJapaneseFullNameToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :japanese_full_name, :string
  end
end
