class CreateParties < ActiveRecord::Migration[7.1]
  def change
    create_table :parties do |t|
      t.integer :host_id, null: false
      t.integer :event_id, null: false
      t.integer :member_limit, null: false, default: 10

      t.timestamps
    end
    add_index :parties, :host_id
    add_index :parties, :event_id
  end
end
