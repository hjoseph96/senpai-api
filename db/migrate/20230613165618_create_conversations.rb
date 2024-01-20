class CreateConversations < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto'

    create_table :conversations, id: :uuid do |t|
      t.references :match, null: false, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
  end
end
