class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :matchee_id

      t.timestamps
    end
    add_index :matches, :matchee_id
  end
end
