class CreateUserLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :user_likes do |t|
      t.references :user, null: false, foreign_key: true, on_delete: :cascade
      t.references :like, null: false, foreign_key: true

      t.timestamps
    end
  end
end
