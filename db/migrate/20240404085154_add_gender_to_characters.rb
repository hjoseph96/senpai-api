class AddGenderToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :gender, :integer
    add_index :characters, :gender
  end
end
