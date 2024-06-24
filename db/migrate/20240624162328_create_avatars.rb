class CreateAvatars < ActiveRecord::Migration[7.1]
  def change
    create_table :avatars do |t|
      t.string :guid, null: false
      t.string :name, null: false
      t.boolean :is_default
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :avatars, :guid
    add_index :avatars, :name
  end
end
