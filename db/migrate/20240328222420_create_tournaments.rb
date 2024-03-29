class CreateTournaments < ActiveRecord::Migration[7.1]
  def change
    create_table :tournaments do |t|
      t.string :title, null: false
      t.integer :tournament_type, null: false
      t.references :user, null: true, foreign_key: true
      t.integer :hours_duration
      t.integer :combatant_count

      t.timestamps
    end
    add_index :tournaments, :title
    add_index :tournaments, :tournament_type
  end
end
