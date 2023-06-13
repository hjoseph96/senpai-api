class CreateGalleries < ActiveRecord::Migration[7.0]
  def change
    create_table :galleries, id: :UUID do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
