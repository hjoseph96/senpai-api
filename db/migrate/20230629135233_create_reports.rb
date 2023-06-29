class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :offense_id
      t.integer :reason
      t.references :conversation, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :reports, :offense_id
  end
end
