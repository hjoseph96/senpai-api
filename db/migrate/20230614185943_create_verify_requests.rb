class CreateVerifyRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :verify_requests do |t|
      t.integer :status, null: false, default: 0
      t.references :user, null: false, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
    add_index :verify_requests, :status
  end
end
