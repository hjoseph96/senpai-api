class CreateMatchRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :match_requests do |t|
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: false
      t.integer :status, default: 0

      t.timestamps
    end
    add_index :match_requests, :sender_id
    add_index :match_requests, :receiver_id
    add_index :match_requests, :status
  end
end
