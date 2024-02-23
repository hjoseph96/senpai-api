class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :score, precision: 1, scale: 1, null: false
      t.integer :review_type, null: false
      t.references :reviewable, polymorphic: true, null: false
      t.text :feedback

      t.timestamps
    end
    add_index :reviews, :review_type
  end
end
