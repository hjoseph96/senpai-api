class CreateBlocks < ActiveRecord::Migration[7.0]
  def change
    create_table :blocks do |t|
      t.integer :blocker_id
      t.integer :blockee_id
      t.references :report, foreign_key: true

      t.timestamps
    end
    add_index :blocks, :blocker_id
    add_index :blocks, :blockee_id
  end
end
