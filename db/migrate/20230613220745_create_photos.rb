class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.references :gallery, null: false, foreign_key: true
      t.integer :order

      t.timestamps
    end
    add_index :photos, :order
  end
end
