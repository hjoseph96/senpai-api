class CreateConventions < ActiveRecord::Migration[7.1]
  def change
    create_table :conventions do |t|
      t.string :title, null: false
      t.string :venue, null: false
      t.string :country, null: false
      t.string :display_city, null: false
      t.string :display_state, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date
      t.string :website
      t.st_point :lonlat, geographic: true, null: false

      t.timestamps
    end
    add_index :conventions, :title
    add_index :conventions, :start_date
    add_index :conventions, :lonlat
  end
end
