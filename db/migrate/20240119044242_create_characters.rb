class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :characters do |t|
      t.references :anime, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.integer :favorites
      t.string :role

      t.timestamps
    end
    add_index :characters, :favorites
    add_index :characters, :role
  end
end
