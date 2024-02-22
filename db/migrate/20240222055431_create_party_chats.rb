class CreatePartyChats < ActiveRecord::Migration[7.1]
  def change
    create_table :party_chats do |t|
      t.references :party, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
