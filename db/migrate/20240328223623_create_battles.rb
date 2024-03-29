class CreateBattles < ActiveRecord::Migration[7.1]
  def change
    create_table :battles do |t|
      t.string :blue_cornerable_type
      t.integer :blue_cornerable_id
      t.string :red_cornerable_type
      t.integer :red_cornerable_id
      t.integer :blue_corner_votes, default: 0
      t.integer :red_corner_votes, default: 0
      t.datetime :started_at
      t.references :round, null: false, foreign_key: true

      t.timestamps
    end
    add_index :battles, :blue_cornerable_id
    add_index :battles, :red_cornerable_id
    add_index :battles, :blue_corner_votes
    add_index :battles, :red_corner_votes
  end
end
