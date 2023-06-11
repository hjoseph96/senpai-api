class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.integer :like_type
      t.references :user, null: false, foreign_key: true
      t.integer :likee_id

      t.timestamps
    end
    add_index :likes, :likee_id
  end
end
