class CreateAnimes < ActiveRecord::Migration[7.0]
  def change
    create_table :animes do |t|
      t.string :title
      t.integer :year
      t.text :genres
      t.integer :popularity
      t.integer :average_score
      t.integer :episodes
      t.boolean :is_adult
      t.string :status
      t.string :studios
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
