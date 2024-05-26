class CreateVideoMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :video_matches, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :matchee_id

      t.timestamps
    end
    add_index :video_matches, :matchee_id
  end
end
