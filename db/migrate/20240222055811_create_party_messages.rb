class CreatePartyMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :party_messages do |t|
      t.integer :sender_id
      t.text :content
      t.integer :reaction
      t.references :party_chat, null: false, foreign_key: true
      t.integer :sticker_id
      t.boolean :read, null: false, default: false
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :party_messages, :sender_id
    add_index :party_messages, :read
  end
end
