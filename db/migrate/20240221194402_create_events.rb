class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :start_date, null: false
      t.datetime :end_date
      t.string :venue, null: false
      t.string :country, null: false
      t.string :display_city, null: false
      t.string :display_state, null: false
      t.st_point :lonlat, geographic: true, null: false
      t.text :description
      t.integer :host_id, null: false
      t.integer :convention_id
      t.integer :cosplay_required, default: 0

      t.timestamps
    end
    add_index :events, :title
    add_index :events, :start_date
    add_index :events, :host_id
  end
end
