class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.integer :sender_id, null: false
      t.text :content, null: false
      t.integer :reaction
      
      t.timestamps
    end
    add_index :messages, :sender_id
  end
end
