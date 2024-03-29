class CreateRounds < ActiveRecord::Migration[7.1]
  def change
    create_table :rounds do |t|
      t.integer :number
      t.integer :tournament_id, null: false

      t.timestamps
    end
  end
end
