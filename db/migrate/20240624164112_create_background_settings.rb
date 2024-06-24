class CreateBackgroundSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :background_settings do |t|
      t.string :title
      t.string :sky_color
      t.string :equator_color
      t.string :ground_color
      t.boolean :enable_stars
      t.boolean :enable_clouds
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :background_settings, :title
  end
end
