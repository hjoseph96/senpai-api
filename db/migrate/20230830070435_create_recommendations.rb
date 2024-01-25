class CreateRecommendations < ActiveRecord::Migration[7.0]
  def change
    create_table :recommendations do |t|
      t.references :user, null: false, foreign_key: true, on_delete: :cascade
      t.integer :recommendee_id, null: false, foreign_key: true
      t.references :anime, null: false, foreign_key: true
      t.references :message, null: false, foreign_key: true

      t.timestamps
    end
    add_index :recommendations, :recommendee_id
  end
end
