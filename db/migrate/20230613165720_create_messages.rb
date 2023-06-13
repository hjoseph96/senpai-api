class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.text :context
      t.integer :reaction
      
      t.timestamps
    end
    add_index :messages, :sender_id
  end
end
