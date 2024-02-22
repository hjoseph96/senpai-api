class CreateJoinRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :join_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.text :description

      t.timestamps
    end
  end
end
