class CreateEventInvites < ActiveRecord::Migration[7.1]
  def change
    create_table :event_invites do |t|
      t.references :event, null: false, foreign_key: true
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: false
      t.integer :status, default: 0
      t.text :content

      t.timestamps
    end
    add_index :event_invites, :sender_id
    add_index :event_invites, :receiver_id
  end
end
